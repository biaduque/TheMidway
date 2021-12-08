//
//  TheMidway_Widget.swift
//  TheMidway Widget
//
//  Created by Beatriz Duque on 08/12/21.
//

import WidgetKit
import SwiftUI
import UIKit

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct TheMidway_WidgetEntryView : View {
    var entry: Provider.Entry
    
    let colors = ["Color1","Color2","Color3","Color4","Color5","Color6","Color7","Color8"]
    let backgrounds = ["Back1","Back2","Back3","Back4","Back5","Back6","Back7","Back8"]
    
    let color1 = Color(uiColor: UIColor(named: "Color1") ?? .systemRed)

    var body: some View {
        GeometryReader{ geometry in
            VStack(){
                VStack(alignment: .leading){
                    Text("Título do encontro")
                        .foregroundColor(.white)
                        .font(Font.system(size: 16, weight: .bold, design: .default))
                        .frame(width: geometry.size.width, height: geometry.size.height/3, alignment: .leading)
                        .offset(x: 5, y: 0)
                }.background(color1)
                VStack(alignment: .leading,spacing: 7){
                    HStack(){
                        Text("Nome do local")
                            .font(Font.system(size: 12, weight: .bold, design: .default))
                            .padding(.top)
                        Image(systemName: "location.fill")
                            .resizable()
                            .foregroundColor(color1)
                            .frame(width: 12, height: 12)
                            .padding(.top)
                    }
                    Text("Rua Antônio Alves de Souza, 22 - Bonfim, Osasco - SP")
                        .font(.caption2)
                        .frame(width: geometry.size.width - 20, height:geometry.size.height/6, alignment: .leading)
                    HStack(){
                        Image(systemName: "calendar")
                            .foregroundColor(color1)
                            .frame(width: 15, height: 15, alignment: .leading)
                        Text("23/10")
                            .font(Font.system(size: 12, weight: .bold, design: .default))
                    }
                    HStack(){
                        Image(systemName: "clock")
                            .foregroundColor(color1)
                            .frame(width: 15, height: 15, alignment: .leading)
                        Text("15h30")
                            .font(Font.system(size: 12, weight: .bold, design: .default))
                    }
                    
                }.frame(width: geometry.size.width - 20, height: geometry.size.height/2.3, alignment: .leading)
            }
           
        }.background(Color(uiColor: UIColor(named: "Back1") ?? .systemRed))
    }
}

@main
struct TheMidway_Widget: Widget {
    
    let kind: String = "TheMidway_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TheMidway_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct TheMidway_Widget_Previews: PreviewProvider {
    static var previews: some View {
        TheMidway_WidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
