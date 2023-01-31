//
//  HealthDashWidgetView.swift
//  HealthDashWidgetExtension
//
//  Created by Caroline Frey on 1/31/23.
//

import SwiftUI

struct CustomColors {
    static let navy = Color("Navy")
    static let background = Color("WidgetBackground")
}

struct HealthDashWidgetView: View {
    let data: DashboardViewController
    
    var body: some View {
        ZStack {
            Color(UIColor(named: "WidgetBackground")!)
            VStack {
                HStack {
                    Text("Weight: ")
                        .font(.headline)
                        .foregroundColor(CustomColors.navy)
                        .font(Font.custom("Oxygen-Regular", size: 24))
                    + Text("\(data.weight)")
                        .font(.body)
                        .foregroundColor(CustomColors.navy)
                        .font(Font.custom("Oxygen-Regular", size: 12))
                    
                    Text("Steps: ")
                        .font(.headline)
                        .foregroundColor(CustomColors.navy)
                        .font(Font.custom("Oxygen-Regular", size: 24))
                    + Text("\(data.stepCount)")
                        .font(.body)
                        .foregroundColor(CustomColors.navy)
                        .font(Font.custom("Oxygen-Regular", size: 12))
                }
    
                HStack {
                    Text("Sleep: ")
                        .font(.headline)
                        .foregroundColor(CustomColors.navy)
                        .font(Font.custom("Oxygen-Regular", size: 24))
                    + Text("\(data.sleepDuration)")
                        .font(.body)
                        .foregroundColor(CustomColors.navy)
                        .font(Font.custom("Oxygen-Regular", size: 12))
                    
                    Text("Calories: ")
                        .font(.headline)
                        .foregroundColor(CustomColors.navy)
                        .font(Font.custom("Oxygen-Regular", size: 24))
                    + Text("\(data.activeEnergy)")
                        .font(.body)
                        .foregroundColor(CustomColors.navy)
                        .font(Font.custom("Oxygen-Regular", size: 12))
                }
            }
        }
    }
}
