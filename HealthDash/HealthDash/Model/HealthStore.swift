//
//  HealthStore.swift
//  HealthDash
//
//  Created by Caroline Frey on 1/12/23.
//

import Foundation
import HealthKit
import WidgetKit

class HealthStore {
    
    var healthStore: HKHealthStore?
    var stepsQuery: HKStatisticsQuery?
    var activeEnergyQuery: HKStatisticsQuery?
    var weightQuery: HKSampleQuery?
    var sleepQuery: HKSampleQuery?
    
    var stepCount = 0.0
    var weight = 0.0
    var sleepDuration = 0.0
    var activeEnergy = 0.0
    
    var stepCountHistory = [Double]()
    var weightHistory = [Double]()
    var sleepDurationHistory = [Double]()
    var activeEnergyHistory = [Double]()
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    //MARK: - Calculate data
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let weightType = HKObjectType.quantityType(forIdentifier: .bodyMass)!
        let stepType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        
        guard let healthStore = self.healthStore else { return completion(false) }
        
        healthStore.requestAuthorization(toShare: [], read: [sleepType, weightType, stepType, activeEnergyType]) { (success, error) in
            completion(success)
        }
    }
    
    func calculateSteps(completion: @escaping (Double) -> Void) {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else {
            fatalError("Unable to retrieve stepCount")
        }
        
        let calendar = NSCalendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        
        guard let startDate = calendar.date(from: components) else {
            fatalError("Unable to create the start date")
        }
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else {
            fatalError("Unable to create the end date")
        }
        
        let today = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        stepsQuery = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: today, options: .cumulativeSum) { (query, results, error ) in
            
            guard let statistics = results else {
                // Handle errors here
                return
            }
            
            let sum = statistics.sumQuantity()
            let totalStepCount = sum?.doubleValue(for: HKUnit.count())
            
            // Update app here
            completion(totalStepCount ?? -1)
        }
        
        if let healthStore = healthStore, let query = self.stepsQuery {
            healthStore.execute(query)
        }
    }
    
    func retrieveWeight(completion: @escaping (Double) -> Void) {
        guard let weightType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            fatalError("Unable to retrieve body mass")
        }
        
        let calendar = NSCalendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        
        guard let startDate = calendar.date(from: components) else {
            fatalError("Unable to create the start date")
        }
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else {
            fatalError("Unable to create the end date")
        }
        
        let today = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        weightQuery = HKSampleQuery.init(sampleType: weightType, predicate: today, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
            
            if let result = results?.first as? HKQuantitySample {
                let bodyMassLB = result.quantity.doubleValue(for: HKUnit.pound())
                completion(bodyMassLB)
            }
            completion(-1.0) // no data
        }
        
        if let healthStore = healthStore, let query = self.weightQuery {
            healthStore.execute(query)
        }
    }
    
    func calculateActiveEnergy(completion: @escaping (Double) -> Void) {
        guard let activeEnergyType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned) else {
            fatalError("Unable to retrieve activeEnergy")
        }
        
        let calendar = NSCalendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        
        guard let startDate = calendar.date(from: components) else {
            fatalError("Unable to create the start date")
        }
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else {
            fatalError("Unable to create the end date")
        }
        
        let today = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        activeEnergyQuery = HKStatisticsQuery(quantityType: activeEnergyType, quantitySamplePredicate: today, options: .cumulativeSum) { (query, results, error ) in
            
            guard let statistics = results else {
                // Handle errors here
                return
            }
            
            let sum = statistics.sumQuantity()
            let totalActiveEnergy = sum?.doubleValue(for: HKUnit.kilocalorie())
            
            // Update app here
            completion(totalActiveEnergy ?? -1)
        }
        
        if let healthStore = healthStore, let query = self.activeEnergyQuery {
            healthStore.execute(query)
        }
    }
    
    func calculateSleep(completion: @escaping (Double) -> Void) {
        guard let sleepType = HKSampleType.categoryType(forIdentifier: .sleepAnalysis) else {
            fatalError("Unable to retrieve body mass")
        }
        
        let calendar = NSCalendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        
        guard let endDate = calendar.date(from: components) else {
            fatalError("Unable to create the start date")
        }
        guard let startDate = calendar.date(byAdding: .day, value: -1, to: endDate) else {
            fatalError("Unable to create the end date")
        }
        
        let today = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [.strictStartDate])
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false) //get most recent data first
        
        sleepQuery = HKSampleQuery(sampleType: sleepType, predicate: today, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            
            var timeInBed = 0.0
            if let result = results {
                if let sample = result.first as? HKCategorySample {
                    if sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue && sample.startDate >= startDate {
                        let sleepTime = sample.endDate.timeIntervalSince(sample.startDate)
                        timeInBed += sleepTime
                    }
                }
                completion(timeInBed)
            }
        }
        
        if let healthStore = healthStore, let query = self.sleepQuery {
            healthStore.execute(query)
        }
    }
    
    func calculateStepsHistory(forPast days: Int, completion: @escaping (Double) -> Void) {
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            print("Unable to create a step count type")
            return
        }
        
        let now = Date()
        let startDate = Calendar.current.date(byAdding: DateComponents(day: -days), to: now)!
        
        var interval = DateComponents()
        interval.day = 1
        
        var anchorComponents = Calendar.current.dateComponents([.day, .month, .year], from: now)
        anchorComponents.hour = 0
        let anchorDate = Calendar.current.date(from: anchorComponents)!
        
        let query = HKStatisticsCollectionQuery(quantityType: stepCountType,
                                                quantitySamplePredicate: nil,
                                                options: [.mostRecent],
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)
        query.initialResultsHandler = { _, results, error in
            guard let results = results else {
                print("ERROR")
                return
            }
            
            results.enumerateStatistics(from: startDate, to: now) { statistics, _ in
                if let sum = statistics.sumQuantity() {
                    let stepCountValue = sum.doubleValue(for: HKUnit.count())
                    completion(stepCountValue)
                    return
                }
            }
        }
        healthStore?.execute(query)
    }
    
    func calculateWeightHistory(forPast days: Int, completion: @escaping (Double) -> Void) {
        guard let weightType = HKObjectType.quantityType(forIdentifier: .bodyMass) else {
            print("Unable to create a weight type")
            return
        }
        
        let now = Date()
        let startDate = Calendar.current.date(byAdding: DateComponents(day: -days), to: now)!
        
        var interval = DateComponents()
        interval.day = 1
        
        var anchorComponents = Calendar.current.dateComponents([.day, .month, .year], from: now)
        anchorComponents.hour = 0
        let anchorDate = Calendar.current.date(from: anchorComponents)!
        
        let query = HKStatisticsCollectionQuery(quantityType: weightType,
                                                quantitySamplePredicate: nil,
                                                options: [.mostRecent],
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)
        query.initialResultsHandler = { _, results, error in
            guard let results = results else {
                print("ERROR")
                return
            }
            
            results.enumerateStatistics(from: startDate, to: now) { statistics, _ in
                if let sum = statistics.mostRecentQuantity() {
                    let weightValue = sum.doubleValue(for: HKUnit.pound())
                    completion(weightValue)
                    return
                }
            }
        }
        healthStore?.execute(query)
    }
    
    func calculateSleepHistory(forPast days: Int, completion: @escaping (Double) -> Void) {
        //TODO: - Implement sleep calculation here
    }
    
    func calculateActiveEnergyHistory(forPast days: Int, completion: @escaping (Double) -> Void) {
        guard let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            print("Unable to create a calorie type")
            return
        }
        
        let now = Date()
        let startDate = Calendar.current.date(byAdding: DateComponents(day: -days), to: now)!
        
        var interval = DateComponents()
        interval.day = 1
        
        var anchorComponents = Calendar.current.dateComponents([.day, .month, .year], from: now)
        anchorComponents.hour = 0
        let anchorDate = Calendar.current.date(from: anchorComponents)!
        
        let query = HKStatisticsCollectionQuery(quantityType: activeEnergyType,
                                                quantitySamplePredicate: nil,
                                                options: [.mostRecent],
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)
        query.initialResultsHandler = { _, results, error in
            guard let results = results else {
                print("ERROR")
                return
            }
            
            results.enumerateStatistics(from: startDate, to: now) { statistics, _ in
                if let sum = statistics.sumQuantity() {
                    let calorieValue = sum.doubleValue(for: HKUnit.kilocalorie())
                    completion(calorieValue)
                    return
                }
            }
        }
        healthStore?.execute(query)
    }
    
    //MARK: - Retrieve Data
    
    func getHealthData() {
        calculateSteps { steps in
            if steps > 0 {
                self.stepCount = steps
            }
        }
        retrieveWeight { weight in
            if weight > 0 {
                self.weight = weight
            }
        }
        calculateActiveEnergy { calories in
            if calories > 0 {
                self.activeEnergy = calories
            }
        }
        calculateSleep { duration in
            if duration > 0 {
                self.sleepDuration = duration
            }
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func getHealthDataHistory() {
        calculateStepsHistory(forPast: 30) { steps in
            self.stepCountHistory.append(steps)
        }
        
        calculateWeightHistory(forPast: 30) { weight in
            self.weightHistory.append(weight)
        }
        
        calculateSleepHistory(forPast: 30) { sleep in
            self.sleepDurationHistory.append(sleep)
        }
        
        calculateActiveEnergyHistory(forPast: 30) { cals in
            self.activeEnergyHistory.append(cals)
        }
    }
}
