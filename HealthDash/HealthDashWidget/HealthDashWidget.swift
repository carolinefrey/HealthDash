//
//  HealthDashWidget.swift
//  HealthDashWidget
//
//  Created by Caroline Frey on 1/31/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), dataView: HealthDashWidgetView(data: DashboardViewController()))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), dataView: HealthDashWidgetView(data: DashboardViewController()))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, dataView: HealthDashWidgetView(data: DashboardViewController()))
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let dataView: HealthDashWidgetView
}

struct HealthDashWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        //Text(entry.date, style: .time)
        HealthDashWidgetView(data: DashboardViewController())
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
        HealthDashWidgetEntryView(entry: Provider.Entry(date: Date(), dataView: HealthDashWidgetView(data: DashboardViewController())))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
