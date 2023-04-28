//
//  ActivityViewContext+Extensions.swift
//  Live Pizza
//
//  Created by Vince Davis on 4/23/23.
//

import WidgetKit
import ActivityKit

extension ActivityViewContext<PizzaResultsAttributes> {
    var fullContext: PizzaResults {
        return PizzaResults(
            type: self.attributes.type,
            results: self.state.results,
            lastUpdated: self.state.lastUpdated,
            updateType: self.state.updateType)
    }
}
