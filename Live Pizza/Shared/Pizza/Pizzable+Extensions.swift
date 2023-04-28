//
//  Pizzable+Extensions.swift
//  Live Pizza
//
//  Created by Vince Davis on 4/23/23.
//

import Foundation
import ActivityKit

extension StaticResultsPizzable {
    var attributes: PizzaResultsAttributes {
        return PizzaResultsAttributes(type: type)
    }
}

extension DynamicResultsPizzable {
    func contentState(type: UpdateType = .cloud) -> PizzaResultsAttributes.ContentState {
        return PizzaResultsAttributes.ContentState(
            results: results,
            lastUpdated: lastUpdated,
            updateType: type.icon)
    }
    
    var totalVotes: Int {
        return results
            .map({ $0.votes })
            .reduce(0, +)
    }
    
    var leader: Pizza? {
        if let pizza = results.max(by: { $0.votes < $1.votes }),
           pizza.votes > 0,
           tie.isEmpty {
            return pizza
        }
        return nil
    }
    
    var tie: [Pizza] {
        if let pizza = results.max(by: { $0.votes < $1.votes }),
           pizza.votes > 0 {
            let tieForFirst = results.filter({ $0.votes == pizza.votes })
            if tieForFirst.count > 1 {
                return tieForFirst
            }
        }
        return []
    }
    
    var deeplink: URL {
        return URL(string: "\(Constants.deepLinkScheme)://deepdish.com")!
    }
    
    var dialog: String {
        if let leader = leader {
            return "The current leader in voting is \(leader.name) with \(leader.votes) votes."
        }
        
        if tie.count > 0 {
            let dialog: String = "There is a tie with \(tie.map({ $0.name }).joined(separator: ", ")). They have \(tie.first?.votes ?? 0) votes"
            return dialog
        }
        
        return "\(results.map({ "\($0.name) has \($0.votes) votes." }))"
    }
}
