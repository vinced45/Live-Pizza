//
//  WidgetLiveActivity.swift
//  Widget
//
//  Created by Vince Davis on 4/23/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct PizzaLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PizzaResultsAttributes.self) { context in
            PizzaVoteView(results: context.fullContext, style: .liveActivity)
                .activitySystemActionForegroundColor(Color.mediumBrown)
                .widgetURL(context.fullContext.deeplink)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    expandedLeading(for: context.fullContext)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    expandedTrailing(for: context.fullContext)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    PizzaVoteView(results: context.fullContext, style: .dynamicIsland)
                        .offset(y: -25)
                }
            } compactLeading: {
                compactLeading(for: context.fullContext)
            } compactTrailing: {
                compactTrailing
            } minimal: {
                minimal(for: context.fullContext)
            }
            .widgetURL(context.fullContext.deeplink)
            .keylineTint(Color.pizzaYellow)
        }
    }
}

// MARK: - Dynamic Views
extension PizzaLiveActivity {
    func expandedLeading(for results: PizzaResults) -> some View {
        Link(destination: results.leader?.deeplink ?? URL(string: "")!, label: {
            Image("\(results.leader?.image ?? "")")
                .resizable()
                .frame(maxWidth: 60, maxHeight: 26)
                .aspectRatio(contentMode: .fit)
                .accessibilityLabel("Logo of leader in voting which is \(results.leader?.name ?? "") with \(results.leader?.votes ?? 0) votes")
        })
    }
    
    func expandedTrailing(for results: PizzaResults) -> some View {
        Image("deepdish")
            .resizable()
            .frame(maxWidth: 30, maxHeight: 26)
            .aspectRatio(1, contentMode: .fill)
            .accessibilityLabel("Deep Dish Swift Logo")
    }
    
    func compactLeading(for results: PizzaResults) -> some View {
        HStack(spacing: 5) {
            Image("\(results.leader?.image ?? "")-small")
                .resizable()
                .frame(width: 26, height: 26)
                .clipShape(Circle())
            Text("\(results.leader?.votes ?? 0)")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.pizzaYellow)
        }
    }
    
    var compactTrailing: some View {
        Text(" \(Text.init(Constants.talkEndDate, style: getStyle(for: Constants.talkEndDate))) ")
            .multilineTextAlignment(.trailing)
            .foregroundColor(.pizzaYellow)
            .font(.caption2)
            .bold()
            .monospacedDigit()
            .frame(maxWidth: getDateSize(for: Constants.talkEndDate))
    }
    
    func minimal(for results: PizzaResults) -> some View {
        Image("\(results.leader?.image ?? "")-small")
            .resizable()
            .frame(width: 26, height: 26)
            .clipShape(Circle())
    }
}

// MARK: - Helpers
extension PizzaLiveActivity {
    
    private func getDateSize(for date: Date) -> CGFloat {
        let diff = date.timeIntervalSinceNow
        if diff > 100 * 60 * 60 {
            return 95
        } else if diff > 10 * 60 * 60 {
            return 90
        } else if diff > 1 * 60 * 60 {
            return 65
        }
        
        return 45
    }
    
    private func getStyle(for date: Date) -> Text.DateStyle {
        let diff = date.timeIntervalSinceNow
        if diff > 10 * 60 * 60 {
            return .relative
        }
        
        return .timer
    }
}

// MARK: - Preview
struct PizzaLiveActivity_Previews: PreviewProvider {
    static let attributes = PizzaResultsAttributes.attributes(for: .votes)
    static let contentState = PizzaResults.preview.contentState()

    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
