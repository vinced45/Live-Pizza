//
//  PizzaResults.swift
//  Live Pizza
//
//  Created by Vince Davis on 4/24/23.
//

import Foundation

struct PizzaResults: Pizzable, Codable {
    var type: LiveActivityType
    var results: [Pizza]
    var lastUpdated: Date
    var updateType: String
}

