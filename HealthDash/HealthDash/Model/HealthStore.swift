//
//  HealthStore.swift
//  HealthDash
//
//  Created by Caroline Frey on 1/12/23.
//

import Foundation
import HealthKit

class HealthStore {
    
    var healthStore: HKHealthStore?
    var stepsQuery: HKStatisticsQuery?
    var weightQuery: HKSampleQuery?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
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
}
