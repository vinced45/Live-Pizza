//
//  PizzaType.swift
//  Live Pizza
//
//  Created by Vince Davis on 4/25/23.
//

import Foundation
import SwiftUI

enum PizzaType: Int, CaseIterable {
    case giordanos = 1
    case louMalnatis
    case bartolis
    case ginos
    
    var name: String {
        switch self {
        case .giordanos: return "Giordano's"
        case .louMalnatis: return "Lou Malnati's"
        case .bartolis: return "Bartoli's"
        case .ginos: return "Gino's East"
        }
    }
    
    var details: String {
        switch self {
        case .giordanos: return "Giordano's"
        case .louMalnatis: return "Lou Malnati's"
        case .bartolis: return "Bartoli's"
        case .ginos: return "Gino's East"
        }
    }
    
    var image: String {
        switch self {
        case .giordanos: return "giordanos"
        case .louMalnatis: return "loumalnatis"
        case .bartolis: return "bartolis"
        case .ginos: return "ginos"
        }
    }
    
    var url: String {
        switch self {
        case .giordanos: return "Giordano's"
        case .louMalnatis: return "Lou Malnati's"
        case .bartolis: return "Bartoli's"
        case .ginos: return "Gino's East"
        }
    }
    
    var color: Color {
        switch self {
        case .giordanos: return .red
        case .louMalnatis: return .pizzaYellow
        case .bartolis: return .mediumBrown
        case .ginos: return .green
        }
    }
    
    func pizza(votes: Int) -> Pizza {
        return .init(id: self.rawValue,
                     name: self.name,
                     details: self.details,
                     image: self.image,
                     url: self.url,
                     votes: votes)
    }
}
