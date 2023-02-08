//
//  HealthDashWidgetView.swift
//  HealthDashWidgetExtension
//
//  Created by Caroline Frey on 1/31/23.
//

import SwiftUI

//TODO: - Move this file to trash (view is built in HealthDashWidget.swift)
//  it is simple enough, doesn't need its own file

struct CustomColors {
    static let background = Color("WidgetBackground")
}

struct HealthDashWidgetView: View {
    let data: HealthStore
    
    var body: some View {
        ZStack {
            Color(UIColor(named: "WidgetBackground")!)
            VStack {
                HStack {
                    Text("Weight: ")
                        .font(.headline)
                        .foregroundColor(.white)
                        .font(Font.custom("Oxygen-Regular", size: 24))
                    + Text("\(data.weight)")
                        .font(.body)
                        .foregroundColor(.white)
                        .font(Font.custom("Oxygen-Regular", size: 12))
                    
                    Text("Steps: ")
                        .font(.headline)
                        .foregroundColor(.white)
                        .font(Font.custom("Oxygen-Regular", size: 24))
                    + Text("\(data.stepCount)")
                        .font(.body)
                        .foregroundColor(.white)
                        .font(Font.custom("Oxygen-Regular", size: 12))
                }
    
                HStack {
                    Text("Sleep: ")
                        .font(.headline)
                        .foregroundColor(.white)
                        .font(Font.custom("Oxygen-Regular", size: 24))
                    + Text("\(data.sleepDuration)")
                        .font(.body)
                        .foregroundColor(.white)
                        .font(Font.custom("Oxygen-Regular", size: 12))
                    
                    Text("Calories: ")
                        .font(.headline)
                        .foregroundColor(.white)
                        .font(Font.custom("Oxygen-Regular", size: 24))
                    + Text("\(data.activeEnergy)")
                        .font(.body)
                        .foregroundColor(.white)
                        .font(Font.custom("Oxygen-Regular", size: 12))
                }
            }
        }
    }
}
