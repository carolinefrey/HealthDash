//
//  SwiftUICell.swift
//  HealthMetricDash
//
//  Created by Caroline Frey on 2/24/23.
//

import SwiftUI
import Foundation

struct SwiftUICell: View {
    static let dashboardCollectionViewCellSwiftUIIdentifier = "DashboardCollectionViewCellSwiftUIIdentifier"
    
    var body: some View {
        HStack {
            ZStack {
                CircularProgressView(progress: 0.8)
                    .frame(width: 110, height: 110)
                
                VStack {
                    Image(systemName: "bed.double.fill")
                        .foregroundColor(.blue)
                        .frame(width: 25, height: 25)
                    
                    Text("8.5 hours")
                        .fontWeight(.bold)
                    
                    Text("in bed")
                }
            }
            
            StepsHistoryView()
                .frame(width: 250, height: 200)
        }
    }
}
