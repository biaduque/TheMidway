//
//  WidgetTheMidway.swift
//  WidgetTheMidway
//
//  Created by Beatriz Duque on 14/12/21.
//

import WidgetKit
import SwiftUI
import TheMidway

struct Provider: TimelineProvider {
    
    
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),nomeLocal: "",dataEncontro: "",endEncontro: "",horaEncontro: "",tituloEncontro: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry =  SimpleEntry(date: Date(),nomeLocal: "",dataEncontro: "",endEncontro: "",horaEncontro: "",tituloEncontro: "")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            
            let nomeLocal = UserDefaultsManager.shared.nomeLocal
            let dataEncontro = UserDefaultsManager.shared.dataEncontro
            let endEncontro = UserDefaultsManager.shared.endEncontro
            let horaEncontro = UserDefaultsManager.shared.horaEncontro
            let tituloEncontro = UserDefaultsManager.shared.tituloEncontro
            
            let entry = SimpleEntry(date: entryDate,
                                    nomeLocal: nomeLocal ?? "Nome do local",
                                    dataEncontro: dataEncontro ?? "23/10",
                                    endEncontro: endEncontro ?? "Endereço do encontro",
                                    horaEncontro: horaEncontro ?? "15h00",
                                    tituloEncontro: tituloEncontro ?? "Meu novo encontro")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    var nomeLocal: String
    var dataEncontro: String
    var endEncontro: String
    var horaEncontro: String
    var tituloEncontro: String
}

struct WidgetTheMidwayEntryView : View {
    let colors = ["Color1","Color2","Color3","Color4","Color5","Color6","Color7","Color8"]
    let backgrounds = ["Back1","Back2","Back3","Back4","Back5","Back6","Back7","Back8"]
    
    var entry: Provider.Entry
    let index = Int.random(in: 0..<8)
    
        var body: some View {
            
            let color1 = Color(uiColor: UIColor(named: colors[index]) ?? .systemRed)
            let back1 = Color(uiColor: UIColor(named: backgrounds[index]) ?? .systemRed)
            
            GeometryReader{ geometry in
                VStack(){
                    VStack(alignment: .leading){
                        Text(entry.tituloEncontro)
                            .foregroundColor(.white)
                            .font(Font.system(size: 16, weight: .bold, design: .default))
                            .frame(width: geometry.size.width, height: geometry.size.height/3, alignment: .leading)
                            .offset(x: 5, y: 0)
                    }.background(color1)
                    VStack(alignment: .leading,spacing: 7){
                        HStack(){
                            Text(entry.nomeLocal)
                                .font(Font.system(size: 12, weight: .bold, design: .default))
                                .padding(.top)
                            Image(systemName: "location.fill")
                                .resizable()
                                .foregroundColor(color1)
                                .frame(width: 12, height: 12)
                                .padding(.top)
                        }
                        Text(entry.endEncontro)
                            .font(.caption2)
                            .frame(width: geometry.size.width - 20, height:geometry.size.height/6, alignment: .leading)
                    
                        HStack(){
                            Image(systemName: "calendar")
                                .foregroundColor(color1)
                                .frame(width: 15, height: 15, alignment: .leading)
                            Text(entry.dataEncontro)
                                .font(Font.system(size: 12, weight: .bold, design: .default))
                        }
                        HStack(){
                            Image(systemName: "clock")
                                .foregroundColor(color1)
                                .frame(width: 15, height: 15, alignment: .leading)
                            Text(entry.horaEncontro)
                                .font(Font.system(size: 12, weight: .bold, design: .default))
                        }
                        
                    }.frame(width: geometry.size.width - 20, height: geometry.size.height/2.3, alignment: .leading)
                }
               
            }.background(back1)
        }
}

@main
struct WidgetTheMidway: Widget {
    let kind: String = "WidgetTheMidway"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetTheMidwayEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct WidgetTheMidway_Previews: PreviewProvider {
    static var previews: some View {
        let nomeLocal = UserDefaultsManager.shared.nomeLocal
        let dataEncontro = UserDefaultsManager.shared.dataEncontro
        let endEncontro = UserDefaultsManager.shared.endEncontro
        let horaEncontro = UserDefaultsManager.shared.horaEncontro
        let tituloEncontro = UserDefaultsManager.shared.tituloEncontro
        
        WidgetTheMidwayEntryView(entry: SimpleEntry(date: Date(),
                                                    nomeLocal: nomeLocal ?? "Nome do local",
                                                    dataEncontro: dataEncontro ?? "23/10",
                                                    endEncontro: endEncontro ?? "Endereço do encontro",
                                                    horaEncontro: horaEncontro ?? "15h00",
                                                    tituloEncontro: tituloEncontro ?? "Meu novo encontro"))
            //.redacted(reason: .placeholder)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            
    }
}
