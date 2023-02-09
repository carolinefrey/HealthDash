//
//  HealthDashWidget.swift
//  HealthDashWidget
//
//  Created by Caroline Frey on 1/31/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    //placeholder widget, used to display preview (should make func that fetches dummy data here)
    func placeholder(in context: Context) -> DashboardEntry {
        DashboardEntry(date: Date(), sleep: 0.0, weight: 0.0, activeEnergy: 0.0, steps: 0.0)
    }
    
    //snapshot of what the widget looks like right now, can use same dummy data as above (I think?)
    func getSnapshot(in context: Context, completion: @escaping (DashboardEntry) -> ()) {
        let entry = DashboardEntry(date: Date(), sleep: 0.0, weight: 0.0, activeEnergy: 0.0, steps: 0.0)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [DashboardEntry] = []
        
        let userDefaults = UserDefaults(suiteName: "group.healthDashWidgetCache")
        let sleep = userDefaults?.value(forKey: "sleep") as? Double ?? 0.0
        let weight = userDefaults?.value(forKey: "weight") as? Double ?? 0.0
        let activeEnergy = userDefaults?.value(forKey: "activeEnergy") as? Double ?? 0.0
        let steps = userDefaults?.value(forKey: "steps") as? Double ?? 0.0
        
        //         Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = DashboardEntry(date: entryDate,
                                       sleep: sleep,
                                       weight: weight,
                                       activeEnergy: activeEnergy,
                                       steps: steps)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

//the data
struct DashboardEntry: TimelineEntry {
    let date: Date
    let sleep: Double
    let weight: Double
    let activeEnergy: Double
    let steps: Double
}

struct HealthDashWidgetEntryView : View {
    var entry: DashboardEntry
    
    var body: some View {
        
        //DATA FORMATTING
        //convert seconds to hours & minutes
        let secondsInAnHour = 3600.0
        let hours = entry.sleep / secondsInAnHour
        let remainder = hours.truncatingRemainder(dividingBy: 1)
        let minutesRemaining = remainder * 60
        let hoursFormatted = String(format: "%.0f", hours)
        let minutes = String(format: "%.0f", minutesRemaining)
        
        let weightFormatted = String(format: "%.1f", entry.weight)
        let activeEnergyFormatted = String(format: "%.0f", entry.activeEnergy)
        let stepsFormatted = String(format: "%.0f", entry.steps)
        
        ZStack {
            Color(UIColor(named: "WidgetBackground")!)
            HStack(spacing: 30) {
                
                VStack(alignment: .leading) {
                    Spacer()
                    
                    HStack {
                        Image(systemName: "bed.double.fill")
                            .font(.system(size: 32))
                        Text("\(hoursFormatted) hrs \(minutes) min")
                            .font(Font.custom("Oxygen-Regular", size: 20))
                    }
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 32))
                        Text("\(activeEnergyFormatted) cals")
                            .font(Font.custom("Oxygen-Regular", size: 20))
                    }
                    
                    Spacer()
                }

                VStack(alignment: .leading) {
                    Spacer()
                    
                    HStack {
                        Image(systemName: "figure.arms.open")
                            .font(.system(size: 32))
                        Text("\(weightFormatted) lbs")
                            .font(Font.custom("Oxygen-Regular", size: 20))
                    }
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "shoeprints.fill")
                            .font(.system(size: 32))
                        Text("\(stepsFormatted) steps")
                            .font(Font.custom("Oxygen-Regular", size: 20))
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

@main
struct HealthDashWidget: Widget {
    let kind: String = "HealthDashWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HealthDashWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Dashboard")
        .description("Display a widget with updated Dashboard metrics.")
        .supportedFamilies([.systemMedium])
    }
}

struct HealthDashWidget_Previews: PreviewProvider {
    static var previews: some View {
        HealthDashWidgetEntryView(entry: Provider.Entry(date: Date(), sleep: 0.0, weight: 0.0, activeEnergy: 0.0, steps: 0.0))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
