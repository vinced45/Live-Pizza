//
//  Pizzable+Preview.swift
//  Live Pizza
//
//  Created by Vince Davis on 4/23/23.
//

import Foundation
import WidgetKit
import ActivityKit
import SwiftUI

// This logic is to use SwiftUI previews.
extension PizzaResultsAttributes {
    static func attributes(for type: LiveActivityType) -> PizzaResultsAttributes {
        let attr = PizzaResultsAttributes(type: type)

        return attr
    }
}

extension PizzaResultsAttributes.ContentState {
    static func contentState(for results: PizzaResults) -> PizzaResultsAttributes.ContentState {
        return results.contentState(type: .cloud)
    }
}

extension PizzaResults {
    static var empty: PizzaResults {
        return PizzaResults(
            type: .votes,
            results: [],
            lastUpdated: Date(),
            updateType: UpdateType.cloud
        )
    }
    
    static var preview: PizzaResults {
        return PizzaResults(
            type: .votes,
            results: [.giordanos, .louMalnatis, .bartolis, .ginos],
            lastUpdated: Date(),
            updateType: UpdateType.cloud
        )
    }
}

extension Pizza {
    static var giordanos: Pizza {
        return .init(id: 1,
                     name: "Giordanos",
                     details: "",
                     image: "giordanos",
                     url: "",
                     votes: 70)
    }
    
    static var louMalnatis: Pizza {
        return .init(id: 2,
                     name: "Lou Malnati's",
                     details: "",
                     image: "loumalnatis",
                     url: "",
                     votes: 50)
    }
    
    static var bartolis: Pizza {
        return .init(id: 3,
                     name: "Bartolis",
                     details: "",
                     image: "bartolis",
                     url: "",
                     votes: 30)
    }
    
    static var ginos: Pizza {
        return .init(id: 4,
                     name: "Gino's East",
                     details: "",
                     image: "ginos",
                     url: "",
                     votes: 40)
    }
}
