//
//  WeightHistoryView.swift
//  HealthMetricDash
//
//  Created by Caroline Frey on 2/11/23.
//

import SwiftUI
import Charts
import Foundation

struct WeightDataModel: Identifiable {
    let id = UUID()
    let value: Double
    let date: Date
}

struct WeightHistoryView: View {
//    var dataHistory: [Double]
//    var list = [DataModel]()
    
//    init(dataHistory: [Double]) {
//        self.dataHistory = dataHistory
//        list = dataHistory.map({ return DataModel(value: $0, date: $1) })
//    }
    
    let list = [
        WeightDataModel(value: 120.3, date: dateFormatter.date(from: "02/01/23") ?? Date()),
        WeightDataModel(value: 125.0, date: dateFormatter.date(from: "02/02/23") ?? Date()),
        WeightDataModel(value: 119.6, date: dateFormatter.date(from: "02/03/23") ?? Date()),
        WeightDataModel(value: 122.2, date: dateFormatter.date(from: "02/04/23") ?? Date()),
        WeightDataModel(value: 130.8, date: dateFormatter.date(from: "02/05/23") ?? Date()),
        WeightDataModel(value: 118.5, date: dateFormatter.date(from: "02/06/23") ?? Date()),
        WeightDataModel(value: 123.3, date: dateFormatter.date(from: "02/07/23") ?? Date()),
        WeightDataModel(value: 124.6, date: dateFormatter.date(from: "02/08/23") ?? Date()),
        WeightDataModel(value: 128.7, date: dateFormatter.date(from: "02/09/23") ?? Date()),
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
            .foregroundStyle(.black)
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .padding(EdgeInsets(top: 50, leading: 25, bottom: 50, trailing: 25))
    }
}
