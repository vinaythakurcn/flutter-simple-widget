//
//  SimpleTodoWidget.swift
//  SimpleTodoWidget
//
//  Created by CN on 09/01/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), task: "Placeholder Task")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry: SimpleEntry
        if context.isPreview{
            entry = placeholder(in: context)
        }
        else{
            // Get the data from the user defaults to display
//            let userDefaults = UserDefaults(suiteName: <YOUR APP GROUP>)
            let userDefaults = UserDefaults(suiteName: "group.todowidget")
            let task = userDefaults?.string(forKey: "todo") ?? "No task available"
            entry = SimpleEntry(date: Date(), task: task)
          }
        completion(entry)
    }

    //    getTimeline is called for the current and optionally future times to update the widget
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        //This just uses the snapshot function you defined earlier
        getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

// The date and any data you want to pass into your app must conform to TimelineEntry
struct SimpleEntry: TimelineEntry {
    let date: Date
    let task: String
}

struct SimpleTodoWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.task)
    }
}

struct SimpleTodoWidget: Widget {
    let kind: String = "SimpleTodoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SimpleTodoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("TODO Widget")
        .description("This is a simple todo widget.")
    }
}

//struct SimpleTodoWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        SimpleTodoWidgetEntryView(entry: SimpleEntry(date: Date()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
