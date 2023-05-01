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
    
    @AppStorage("accessibility", store: UserDefaults(suiteName: Constants.appGroup))
    var enableAccessibility: Bool = true
    
    @AppStorage("dynamicText", store: UserDefaults(suiteName: Constants.appGroup))
    var enableDynamicText: Bool = true
    
    var body: some View {
        VStack(spacing: 2) {
            headerView
            
            votesView
            
            PizzaProgressView(start: Constants.progressStartDate, end: Constants.talkEndDate)
                .offset(y: style.offset)
                .if(enableAccessibility, transform: { view in
                    view
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("Voting ends progress. \(Text.init(Constants.talkEndDate, style: .relative)) time remaining")
                })

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
                        .if(enableAccessibility, transform: { view in
                            view.accessibilityLabel("Logo of leader in voting which is \(results.leader?.name ?? "") with \(results.leader?.votes ?? 0) votes")
                        })
                })
                
                HStack {
                    Spacer ()
                    Image("deepdish")
                        .resizable()
                        .frame(maxWidth: 30, maxHeight: 26)
                        .aspectRatio(1, contentMode: .fill)
                        .if(enableAccessibility, transform: { view in
                            view.accessibilityLabel("Deep Dish Swift Logo")
                        })
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
                .if(enableDynamicText, transform: { view in
                    view.dynamicTypeSize(...DynamicTypeSize.large)
                })
                
            Text("\(votes)")
                .font(.title)
                .bold()
                .foregroundColor(color)
                .if(enableDynamicText, transform: { view in
                    view.dynamicTypeSize(...DynamicTypeSize.large)
                })
        }
        .padding(3)
        .if(enableAccessibility, transform: { view in
            view
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(text) has \(votes) votes")
        })
        
    }
    
    var bottomView: some View {
        HStack {
            votingEndsText
                .font(.caption)
                .bold()
                .if(enableDynamicText, transform: { view in
                    view.dynamicTypeSize(...DynamicTypeSize.xLarge)
                })
                .foregroundColor(.primaryText)
                .multilineTextAlignment(.leading)
                    
            Spacer()
            
            VStack(alignment: .trailing, spacing: 0) {
                HStack(spacing: 3) {
                    Image(systemName: results.updateType.icon)
                    Text("Updated")
                }
                Text(" \(Text.init(results.lastUpdated, style: .relative))")
                    .multilineTextAlignment(.trailing)
            }
            .font(.caption2)
            .if(enableDynamicText, transform: { view in
                view.dynamicTypeSize(...DynamicTypeSize.xLarge)
            })
            .if(enableAccessibility, transform: { view in
                view
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Last updated from \(results.updateType.rawValue) \(Text.init(results.lastUpdated, style: .relative))")
            })
            .foregroundColor(.secondaryText)
            .frame(maxWidth: 100)
            .if(style == .dynamicIsland, transform: { view in
                view.padding(.trailing, 10)
            })
        }
        .offset(y: style.offset)
    }
    
    var votingEndsText: some View {
        if Constants.talkEndDate > Date.now {
            return Text("Voting ends in \(Text.init(Constants.talkEndDate, style: .relative))")
        } else {
            return Text("Voting has ended")
        }
    }
}

struct PizzaChartView_Previews: PreviewProvider {
    static var previews: some View {
        PizzaVoteView(results: PizzaResults.preview, style: .liveActivity)
            .frame(width: 400, height: 180)
    }
}
