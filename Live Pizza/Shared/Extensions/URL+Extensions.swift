//
//  URL+Extensions.swift
//  Live Pizza
//
//  Created by Vince Davis on 4/26/23.
//

import Foundation

extension URL {
    /// SwifterSwift: Dictionary of the URL's query parameters.
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else { return nil }

        var items: [String: String] = [:]

        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }

        return items
    }
}
