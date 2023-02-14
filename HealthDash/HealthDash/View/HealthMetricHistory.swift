//
//  HealthMetricHistory.swift
//  HealthMetricDash
//
//  Created by Caroline Frey on 2/11/23.
//

import SwiftUI
import Charts
import Foundation

struct DataModel: Identifiable {
    let id = UUID()
    let value: Double
    let date: Date
}

struct HealthMetricHistory: View {
    var dataHistory: [Double]
//    var list = [DataModel]()
    
//    init(dataHistory: [Double]) {
//        self.dataHistory = dataHistory
//        list = dataHistory.map({ return DataModel(value: $0, date: $1) })
//    }
    
    let list = [
        DataModel(value: 120.3, date: dateFormatter.date(from: "02/01/23") ?? Date()),
        DataModel(value: 125.0, date: dateFormatter.date(from: "02/02/23") ?? Date()),
        DataModel(value: 119.6, date: dateFormatter.date(from: "02/03/23") ?? Date()),
        DataModel(value: 122.2, date: dateFormatter.date(from: "02/04/23") ?? Date()),
    ]
    
    static var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yy"
        return df
    }()
    
    var body: some View {
        Chart(list) { dataPoint in
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
            .foregroundStyle(.red)
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
    }
}
