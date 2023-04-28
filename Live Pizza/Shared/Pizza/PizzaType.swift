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
        case .giordanos: return "Giordano’s is constantly making headlines, both in Chicago and nationally. The brand garners frequent media coverage and continuously tops “Best Pizza” lists and dining guides. Giordano’s has been acclaimed “Chicago’s Best Pizza” by NBC, CBS Chicago, New York Times, Chicago Magazine, Chicago Tribune, Chicago Eater, Home & Garden Magazine, Concierge Preferred and more!"
        case .louMalnatis: return "Lou Malnati got his start in the 1940's working in Chicago's first deep dish pizzeria. He took his pizza expertise to Lincolnwood, a northern suburb of Chicago, where he and his wife Jean opened the first Lou Malnati's Pizzeria on March 17, 1971. Lou was known for his fun-loving character as well as making Chicago's best pizza. Loyal patrons lined the streets on opening day for a taste of his delicious deep dish creations. Lou always thought it was funny that an Italian should open a pizzeria in a Jewish neighborhood on an Irish holiday. But that was Lou's style; he loved all types of people and didn't care much about what people thought."
        case .bartolis: return "Brian Tondryk, Owner and Founder, cherishes the significance of family tradition. Carrying on the legacy of his grandfather, Fred Bartoli, he craved to create an experience for pizza lovers similar to his own. Growing up, Brian witnessed his grandfather build his own pizza empire and succeed at every turn. Fully understanding the pizza industry, Brian scratched his entrepreneurial itch and founded Bartoli’s Pizzeria in 2013."
        case .ginos: return "Since opening in 1966, Gino’s East has maintained its reputation as one of Chicago’s most loved pizzerias! The original Gino's East was opened by two taxi drivers, Sam Levine and Fred Bartoli, along with a friend, George Loverde. Driving up and down the Magnificent Mile, Levine and Bartoli knew a hit pizza spot right off of this busy stretch of road would be a sound investment. From this decision, Gino’s East was born! Our flagship is located at 162 E Superior St. – just steps away from the famed Magnificent Mile where the original Gino’s idea was born."
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
        case .giordanos: return "https://giordanos.com"
        case .louMalnatis: return "https://www.loumalnatis.com"
        case .bartolis: return "https://www.bartolispizzeria.com"
        case .ginos: return "https://www.ginoseast.com"
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
    
    func pizza(votes: Int = 0) -> Pizza {
        return .init(id: self.rawValue,
                     name: self.name,
                     details: self.details,
                     image: self.image,
                     url: self.url,
                     votes: votes)
    }
}
