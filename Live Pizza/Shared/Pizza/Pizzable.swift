//
//  Pizzable.swift
//  Live Pizza
//
//  Created by Vince Davis on 4/23/23.
//

import Foundation

enum LiveActivityType: String, Codable {
    case votes
    case leader
}

protocol StaticResultsPizzable {
    var type: LiveActivityType { get }
}

protocol DynamicResultsPizzable {
    var results: [Pizza] { get }
    var lastUpdated: Date { get }
    var updateType: String { get }
}

typealias Pizzable = StaticResultsPizzable & DynamicResultsPizzable

