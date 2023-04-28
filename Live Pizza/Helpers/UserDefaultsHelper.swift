//
//  UserDefaultsHelper.swift
//  Live Pizza
//
//  Created by Vince Davis on 4/24/23.
//

import Foundation

struct UserDefaultsHelper {
    static func getPizzaResults() async -> PizzaResults? {
        if let userDefaults = UserDefaults(suiteName: Constants.appGroup),
           let dataObject = userDefaults.object(forKey: Constants.resultsDefaultsKey) as? Data,
           let pizzaResults = try? JSONDecoder().decode(PizzaResults.self, from: dataObject) {
            return pizzaResults
        } else {
            return nil
        }
    }
    
    static func save(results: PizzaResults) {
        guard let data = try? JSONEncoder().encode(results) else {
            //TODO: get rid of this
            fatalError("oops")
        }
        
        if let udSuite = UserDefaults(suiteName: Constants.appGroup) {
            udSuite.set(data, forKey: Constants.resultsDefaultsKey)
        }
    }
}
