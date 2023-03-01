//
//  SwiftUICell.swift
//  HealthMetricDash
//
//  Created by Caroline Frey on 2/24/23.
//

import SwiftUI
import Foundation

protocol CellContent {
    var healthStore: HealthStore { get }
    var dataType: Data { get }
    var dataValue: Double { get }
    var detailLabel: String { get }
    var icon: String { get }
    var target: Double { get }
}

struct SwiftUICell: View {
    
    let content: CellContent
    
    var body: some View {
        let progress = content.dataValue / content.target
        
        HStack {
            ZStack {
                CircularProgressView(progress: progress)
                    .frame(width: 110, height: 110)
                
                VStack {
                    Image(systemName: "\(content.icon)")
                        .foregroundColor(Color("Navy"))
                        .frame(width: 25, height: 25)
                    
                    Text(content.dataType == .sleep ? "\(String(format: "%.1f", formatSleepData(data: content.dataValue))) hrs" : "\(String(format: "%.1f", content.dataValue))")
                        .foregroundColor(Color("Navy"))
                        .fontWeight(.bold)
                    
                    Text("\(content.detailLabel)")
                        .foregroundColor(Color("Navy"))
                }
            }
            
            HistoryGraphView(dataPoints: fetchHistoricData(healthStore: content.healthStore, dataType: content.dataType))
        }
        .background(.white)
    }
}

func formatSleepData(data: Double) -> Double {
    return data / 3600.0
}

func fetchHistoricData(healthStore: HealthStore, dataType: Data) -> [Double] {
//    let userDefaults = UserDefaults(suiteName: "group.healthDashWidgetCache")
    
    switch dataType {
    case .sleep:
//        return userDefaults?.value(forKey: UserDefaultsKey.sleepHistory.rawValue) as! [Double]
        return healthStore.sleepDurationHistory
    case .weight:
        return healthStore.weightHistory
    case .activeEnergy:
        return healthStore.activeEnergyHistory
    case .steps:
        return healthStore.stepCountHistory
    }
}
