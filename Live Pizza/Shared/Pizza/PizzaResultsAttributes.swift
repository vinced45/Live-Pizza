//
//  PizzaAttributes.swift
//  Live Pizza
//
//  Created by Vince Davis on 4/23/23.
//

import Foundation
import ActivityKit

struct PizzaResultsAttributes: ActivityAttributes, StaticResultsPizzable {
    var type: LiveActivityType
    
    typealias State = PizzaResultsAttributes.ContentState
    
    struct ContentState: Codable, Hashable, DynamicResultsPizzable {
        var results: [Pizza]
        var lastUpdated: Date
        var updateType: String
        
        static func == (lhs: PizzaResultsAttributes.ContentState, rhs: PizzaResultsAttributes.ContentState) -> Bool {
            lhs.lastUpdated == rhs.lastUpdated
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(lastUpdated)
        }
    }
}
