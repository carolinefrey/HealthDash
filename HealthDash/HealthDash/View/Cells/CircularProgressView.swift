//
//  CircularProgressView.swift
//  HealthMetricDash
//
//  Created by Caroline Frey on 2/11/23.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color("TrackColor"),
                    lineWidth: 10
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color("Navy"),
                    style: StrokeStyle (
                        lineWidth: 10,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
        }
        
    }
}
