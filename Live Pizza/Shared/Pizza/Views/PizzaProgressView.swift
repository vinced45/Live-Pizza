//
//  PizzaProgressView.swift
//  Live Pizza
//
//  Created by Vince Davis on 4/24/23.
//

import WidgetKit
import SwiftUI


struct PizzaProgressView: View {
    var start: Date
    var end: Date
    @State var now: Date = Date()
    let total: Double = 110.0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(start: Date = Date(), end: Date) {
        self.start = start
        self.end = end
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            Image(systemName: "flag.circle.fill")
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.image)
                .font(.title)
            
            ProgressView(value: value, total: total)
                .frame(height: 24)
                .progressViewStyle(PizzaProgress())
                .clipped()
                .onReceive(timer) { _ in
                    now = Date.now
                }
            
            Image(systemName: "flag.2.crossed.circle.fill")
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.image)
                .font(.title)
        }
        
    }
    
    var value: Double {
        if start > now {
            return 0
        }
        if now > end {
            return 100
        }
        let totalValue = DateInterval(start: start, end: end).duration / 60
        let current = DateInterval(start: start, end: now).duration / 60
        let newValue = (current / totalValue) * 100.0

        return newValue
    }
}

struct PizzaProgress: ProgressViewStyle {
    var thumbImage: String = "🍕"
    var minTrackColor: Color = .darkBrown
    var maxTrackColor: Color = .progressGray

    func makeBody(configuration: Configuration) -> some View {
        let completed = configuration.fractionCompleted ?? 0
        return GeometryReader { gr in
            let radius = gr.size.height * 0.5
            ZStack {
                dashedLine(with: gr, radius: radius, completed: completed)

                solidLine(with: gr, radius: radius, completed: completed)

                pizza(with: gr, completed: completed)
            }
        }
    }
    
    func dashLineWidth(from geo: GeometryProxy, completion: Double) -> Double {
        return (geo.size.width - 30) - (geo.size.width * completion)
    }
    
    func solidLineWidth(from geo: GeometryProxy, completion: Double) -> Double {
        return (geo.size.width * completion) - 5
    }
    
    func pizzaLocation(for geo: GeometryProxy, completion: Double) -> Double {
        return geo.size.width * completion
    }
    
    @ViewBuilder
    func dashedLine(with geo: GeometryProxy, radius: Double, completed: Double) -> some View {
        HStack {
            Spacer()
            
            Line()
                .stroke(style: StrokeStyle(lineWidth: geo.size.height / 8, lineCap: .round, dash: [geo.size.height * 0.4]))
                .foregroundColor(maxTrackColor)
                .frame(width: dashLineWidth(from: geo, completion: completed),
                       height: geo.size.height * 0.95
                )
//                .frame(width: geo.size.width,
//                       height: geo.size.height * 0.95
//                )
                .clipShape(RoundedRectangle(cornerRadius: radius))
        }
    }
    
    @ViewBuilder
    func solidLine(with geo: GeometryProxy, radius: Double, completed: Double) -> some View {
        HStack {
            Rectangle()
                //.foregroundColor(minTrackColor)
                .fill(
                    LinearGradient(gradient: Gradient(colors: [
                        .clear,
                        .pizzaYellow.opacity(0.2),
                        .pizzaYellow.opacity(0.5),
                        .mediumBrown.opacity(0.8),
                        minTrackColor
                    ]), startPoint: .leading, endPoint: .trailing)
                    )
                .frame(width: solidLineWidth(from: geo, completion: completed),
                       height: geo.size.height * 0.25)
                .cornerRadius(radius)
                .opacity(1.0)
            
            Spacer()
        }
        .clipShape(RoundedRectangle(cornerRadius: radius))
    }
    
    @ViewBuilder
    func pizza(with geo: GeometryProxy, completed: Double) -> some View {
        HStack {
            Text(thumbImage)
                .frame(width: 24, height: 24)
                .offset(x: pizzaLocation(for: geo, completion: completed))
                .opacity(1.0)
            
            Spacer()
        }
    }
}

struct PizzaProgressView_Previews: PreviewProvider {
    static var previews: some View {
        let start = Date.now.addingTimeInterval(-0.5 * 60)
        let end = Date.now.addingTimeInterval(1 * 60)
        
        PizzaProgressView(start: start, end: end)
            .frame(height: 10)
            .padding()
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

