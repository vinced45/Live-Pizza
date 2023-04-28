//
//  PizzaChartView.swift
//  Live Pizza
//
//  Created by Vince Davis on 4/23/23.
//

import SwiftUI
import Charts

struct PizzaVoteView: View {
    let results: Pizzable
    let style: ViewStyle
    
    var body: some View {
        VStack(spacing: 2) {
            headerView
            
            votesView
            
            PizzaProgressView(start: Constants.progressStartDate, end: Constants.talkEndDate)
                .offset(y: style.offset)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Voting ends progress. \(Text.init(Constants.talkEndDate, style: .relative)) time remaining")
            
            bottomView
        }
        .padding(.horizontal, 10)
        .padding(.vertical)
        .if(style == .liveActivity, transform: { view in
            view.background(Color.laBackground)
        })
    }
    
    var headerView: some View {
        if style != .dynamicIsland {
            return AnyView(ZStack {
                Link(destination: results.leader?.deeplink ?? URL(string: "http://deepdishswift.com")!, label: {
                    Image(results.leader?.image ?? "")
                        .resizable()
                        .frame(maxWidth: 120, maxHeight: 50)
                        .aspectRatio(contentMode: .fit)
                        .accessibilityLabel("Logo of leader in voting which is \(results.leader?.name ?? "") with \(results.leader?.votes ?? 0) votes")
                })
                
                HStack {
                    Spacer ()
                    Image("deepdish")
                        .resizable()
                        .frame(maxWidth: 30, maxHeight: 26)
                        .aspectRatio(1, contentMode: .fill)
                        .accessibilityLabel("Deep Dish Swift Logo")
                }
            })
        } else { return AnyView(EmptyView()) }
    }
    
    var votesView: some View {
        HStack(spacing: 10) {
            ForEach(results.results) { pizza in
                let color: Color = results.leader?.id ?? 0 == pizza.id ? .leaderText : .primaryText
                header(pizza.name, with: pizza.votes, color: color)
            }
        }
    }
    
    func header(_ text: String, with votes: Int, color: Color = .primaryText) -> some View {
        VStack(alignment: .center) {
            Text(text)
                .font(.caption)
                .foregroundColor(.secondaryText)
                .dynamicTypeSize(...DynamicTypeSize.large)
                
            Text("\(votes)")
                .font(.title)
                .bold()
                .foregroundColor(color)
                .dynamicTypeSize(...DynamicTypeSize.large)
        }
        .padding(3)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(text) has \(votes) votes")
    }
    
    var bottomView: some View {
        HStack {
            Text("Voting ends in \(Text.init(Constants.talkEndDate, style: .relative))")
                .font(.caption)
                .bold()
                .dynamicTypeSize(...DynamicTypeSize.xLarge)
                .foregroundColor(.primaryText)
                .multilineTextAlignment(.leading)
            Spacer()
            
            VStack(alignment: .trailing, spacing: 0) {
                HStack(spacing: 3) {
                    Image(systemName: results.updateType)
                    Text("Updated")
                }
                Text(" \(Text.init(results.lastUpdated, style: .relative))")
                    .multilineTextAlignment(.trailing)
            }
            .font(.caption2)
            .dynamicTypeSize(...DynamicTypeSize.xLarge)
            .foregroundColor(.secondaryText)
            .frame(maxWidth: 100)
            .if(style == .dynamicIsland, transform: { view in
                view.padding(.trailing, 10)
            })
        }
        .offset(y: style.offset)
    }
}

struct PizzaChartView_Previews: PreviewProvider {
    static var previews: some View {
        PizzaVoteView(results: PizzaResults.preview, style: .liveActivity)
            .frame(width: 400, height: 180)
    }
}
