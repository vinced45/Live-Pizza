//
//  PizzaVote.swift
//  Live Pizza
//
//  Created by Vince Davis on 4/24/23.
//

import Foundation
import CloudKit

struct PizzaVote: Codable, Hashable, Equatable {
    let pizzaId: Int
    let name: String
    let user: String
}

extension PizzaVote: Identifiable {
    var id: Int {
        return self.pizzaId
    }
}

enum PizzaVoteRecordKeys: String {
    case type = "PizzaVote"
    case pizzaId
    case name
    case user
}

extension PizzaVote {
    func record() -> CKRecord {
        let record = CKRecord(recordType: PizzaVoteRecordKeys.type.rawValue)
        record[PizzaVoteRecordKeys.pizzaId.rawValue] = pizzaId
        record[PizzaVoteRecordKeys.name.rawValue] = name
        record[PizzaVoteRecordKeys.user.rawValue] = user
        return record
    }
    
    init?(from record: CKRecord) {
        guard
            let pizzaId = record[PizzaVoteRecordKeys.pizzaId.rawValue] as? Int,
            let name = record[PizzaVoteRecordKeys.name.rawValue] as? String,
            let user = record[PizzaVoteRecordKeys.user.rawValue] as? String
        else { return nil }
        self = .init(pizzaId: pizzaId, name: name, user: user)
    }
}

extension Array<PizzaVote> {
    func getPizzaResults() -> PizzaResults {
        var pizzas: [Pizza] = []
        for pizza in PizzaType.allCases {
            let count = self.filter({ $0.pizzaId == pizza.rawValue }).count
            pizzas.append(pizza.pizza(votes: count))
        }
        
        return PizzaResults(type: .votes, results: pizzas, lastUpdated: Date(), updateType: .cloud)
    }
}
