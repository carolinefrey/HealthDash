//
//  HistoryGraphView.swift
//  HealthMetricDash
//
//  Created by Caroline Frey on 2/26/23.
//

import SwiftUI
import Charts
import Foundation

struct HistoryDataModel: Identifiable {
    let id = UUID()
    let value: Double
    let date: Int
}

struct HistoryGraphView: View {
    
    let dataPoints: [Double]
    
    var body: some View {
        let dataHistory = formatDataPoints(data: dataPoints)
        
        Chart(dataHistory) { dataPoint in
            AreaMark(
                x: .value("Date", dataPoint.date),
                yStart: .value("Value", dataPoint.value),
                yEnd: .value("minValue", 0)
            )
            .foregroundStyle(.gray)
            .interpolationMethod(.cardinal)
            
            LineMark(
                x: .value("Date", dataPoint.date),
                y: .value("Value", dataPoint.value)
            )
            .interpolationMethod(.cardinal)
            .foregroundStyle(.black)
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .padding(EdgeInsets(top: 50, leading: 25, bottom: 50, trailing: 25))
    }
}

private func formatDataPoints(data: [Double]) -> [HistoryDataModel] {
    var dataHistory: [HistoryDataModel] = []
    for i in 0..<data.count {
        let newEntry = HistoryDataModel(value: data[i], date: i)
        dataHistory.append(newEntry)
    }
    return dataHistory
}
