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
        DashboardEntry(date: Date(), weight: 125.0, activeEnergy: 432, steps: 5698)
    }
    
    //snapshot of what the widget looks like right now, can use same dummy data as above (I think?)
    func getSnapshot(in context: Context, completion: @escaping (DashboardEntry) -> ()) {
        let entry = DashboardEntry(date: Date(), weight: 125.0, activeEnergy: 432, steps: 5698)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [DashboardEntry] = []
        
        let userDefaults = UserDefaults(suiteName: "group.healthDashWidgetCache")
//        let sleep = userDefaults?.value(forKey: UserDefaultsKey.sleep.rawValue) as? Double ?? 0.0
        let weight = userDefaults?.value(forKey: UserDefaultsKey.weight.rawValue) as? Double ?? 0.0
        let activeEnergy = userDefaults?.value(forKey: UserDefaultsKey.activeEnergy.rawValue) as? Double ?? 0.0
        let steps = userDefaults?.value(forKey: UserDefaultsKey.steps.rawValue) as? Double ?? 0.0
        
        //Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0..<5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = DashboardEntry(date: entryDate,
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
//    let sleep: Double
    let weight: Double
    let activeEnergy: Double
    let steps: Double
}

struct HealthMetricDashWidgetEntryView : View {
    var entry: DashboardEntry
    
    var body: some View {
        
        //DATA FORMATTING
        //convert seconds to hours & minutes
//        let secondsInAnHour = 3600.0
//        let hours = entry.sleep / secondsInAnHour
//        let remainder = hours.truncatingRemainder(dividingBy: 1)
//        let minutesRemaining = remainder * 60
//        let hoursFormatted = String(format: "%.0f", hours)
//        let minutes = String(format: "%.0f", minutesRemaining)
        
        let weightFormatted = String(format: "%.1f", entry.weight)
        let activeEnergyFormatted = String(format: "%.0f", entry.activeEnergy)
        let stepsFormatted = String(format: "%.0f", entry.steps)
        
        //retrieve targets
        let userDefaults = UserDefaults(suiteName: "group.healthDashWidgetCache")
//        let sleepTarget = Double(userDefaults?.double(forKey: UserDefaultsKey.targetSleep.rawValue) ?? 0.0)
        let weightTarget = Double(userDefaults?.double(forKey: UserDefaultsKey.targetWeight.rawValue) ?? 0.0)
        let calorieTarget = Double(userDefaults?.double(forKey: UserDefaultsKey.targetCalories.rawValue) ?? 0.0)
        let stepTarget = Double(userDefaults?.double(forKey: UserDefaultsKey.targetSteps.rawValue) ?? 0.0)
        
        ZStack {
            Color(UIColor(named: "WidgetBackground")!)
            
            HStack(spacing: -50) {
                VStack(alignment: .leading, spacing: 30) {
                    
                    VStack {
                        HStack {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 18))
                                .foregroundColor(Color("TextColor"))
                            Text("\(activeEnergyFormatted) cals")
                                .font(Font.custom("Oxygen-Regular", size: 18))
                                .foregroundColor(Color("TextColor"))
                        }
                        HStack(spacing: -20) {
                            ProgressView(value: entry.activeEnergy, total: calorieTarget)
                                .progressViewStyle(LinearProgressViewStyle(tint: (Color("TextColor"))))
                                .scaleEffect(x: 0.5, y: 0.8, anchor: .center)
                            if entry.activeEnergy >= calorieTarget {
                                Image(systemName: "checkmark.circle")
                                    .resizable().frame(width: 15, height: 15)
                            } else {
                                EmptyView()
                            }
                        }
                        .padding([.leading, .trailing], 30)
                    }
                }
                
                VStack(alignment: .leading, spacing: 30) {
                    VStack {
                        HStack {
                            Image(systemName: "figure.arms.open")
                                .font(.system(size: 18))
                                .foregroundColor(Color("TextColor"))
                            Text("\(weightFormatted) lbs")
                                .font(Font.custom("Oxygen-Regular", size: 18))
                                .foregroundColor(Color("TextColor"))
                        }
                        HStack(spacing: -20) {
                            ProgressView(value: entry.weight, total: weightTarget)
                                .progressViewStyle(LinearProgressViewStyle(tint: (Color("TextColor"))))
                                .scaleEffect(x: 0.5, y: 0.8, anchor: .center)
                            if entry.weight >= weightTarget {
                                Image(systemName: "checkmark.circle")
                                    .resizable().frame(width: 15, height: 15)
                            } else {
                                EmptyView()
                            }
                        }
                        .padding([.leading, .trailing], 30)
                    }
                    
                    VStack {
                        HStack {
                            Image(systemName: "shoeprints.fill")
                                .font(.system(size: 18))
                                .foregroundColor(Color("TextColor"))
                            Text("\(stepsFormatted) steps")
                                .font(Font.custom("Oxygen-Regular", size: 18))
                                .foregroundColor(Color("TextColor"))
                        }
                        HStack(spacing: -20) {
                            ProgressView(value: entry.steps, total: stepTarget)
                                .progressViewStyle(LinearProgressViewStyle(tint: (Color("TextColor"))))
                                .scaleEffect(x: 0.5, y: 0.8, anchor: .center)
                            if entry.steps >= stepTarget {
                                Image(systemName: "checkmark.circle")
                                    .resizable().frame(width: 15, height: 15)
                            } else {
                                EmptyView()
                            }
                        }
                        .padding([.leading, .trailing], 30)
                    }
                }
            }
        }
    }
}

@main
struct HealthMetricDash: Widget {
    let kind: String = "HealthMetricDashWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HealthMetricDashWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Dashboard")
        .description("Display a widget with updated Dashboard metrics.")
        .supportedFamilies([.systemMedium])
    }
}

struct HealthMetricDashWidget_Previews: PreviewProvider {
    static var previews: some View {
        HealthMetricDashWidgetEntryView(entry: Provider.Entry(date: Date(), weight: 0.0, activeEnergy: 0.0, steps: 0.0))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
