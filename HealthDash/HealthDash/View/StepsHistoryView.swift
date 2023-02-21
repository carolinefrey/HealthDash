//
//  StepsHistoryView.swift
//  HealthMetricDash
//
//  Created by Caroline Frey on 2/15/23.
//

import SwiftUI
import Charts
import Foundation

struct StepsDataModel: Identifiable {
    let id = UUID()
    let value: Double
    let date: Date
}

struct StepsHistoryView: View {
//    var dataHistory: [Double]
//    var list = [DataModel]()
    
//    init(dataHistory: [Double]) {
//        self.dataHistory = dataHistory
//        list = dataHistory.map({ return DataModel(value: $0, date: $1) })
//    }
    
    let list = [
        StepsDataModel(value: 1234, date: dateFormatter.date(from: "02/01/23") ?? Date()),
        StepsDataModel(value: 3567, date: dateFormatter.date(from: "02/02/23") ?? Date()),
        StepsDataModel(value: 10000, date: dateFormatter.date(from: "02/03/23") ?? Date()),
        StepsDataModel(value: 8795, date: dateFormatter.date(from: "02/04/23") ?? Date()),
        StepsDataModel(value: 9837, date: dateFormatter.date(from: "02/05/23") ?? Date()),
        StepsDataModel(value: 5039, date: dateFormatter.date(from: "02/06/23") ?? Date()),
        StepsDataModel(value: 1090, date: dateFormatter.date(from: "02/07/23") ?? Date()),
        StepsDataModel(value: 10000, date: dateFormatter.date(from: "02/08/23") ?? Date()),
        StepsDataModel(value: 8974, date: dateFormatter.date(from: "02/09/23") ?? Date()),
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
        .padding(EdgeInsets(top: 50, leading: 25, bottom: 50, trailing: 25))
    }
}
