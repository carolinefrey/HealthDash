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
}

