//
//  SwiftUICell.swift
//  HealthMetricDash
//
//  Created by Caroline Frey on 2/24/23.
//

import SwiftUI
import Foundation

protocol CellContent {
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
        let historicData = [0.0]
        
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
            
            HistoryGraphView(dataPoints: fetchHistoricData(dataType: content.dataType))
        }
    }
}

func formatSleepData(data: Double) -> Double {
    return data / 3600.0
}

func fetchHistoricData(dataType: Data) -> [Double] {
    let userDefaults = UserDefaults(suiteName: "group.healthDashWidgetCache")
    
    switch dataType {
    case .sleep:
        return userDefaults?.value(forKey: UserDefaultsKey.sleepHistory.rawValue) as! [Double]
    case .weight:
        return userDefaults?.value(forKey: UserDefaultsKey.weightHistory.rawValue) as! [Double]
    case .activeEnergy:
        return userDefaults?.value(forKey: UserDefaultsKey.activeEnergyHistory.rawValue) as! [Double]
    case .steps:
        return userDefaults?.value(forKey: UserDefaultsKey.stepsHistory.rawValue) as! [Double]
    }
}
