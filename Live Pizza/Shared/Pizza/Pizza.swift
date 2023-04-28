//
//  Pizza.swift
//  Live Pizza
//
//  Created by Vince Davis on 4/23/23.
//

import Foundation

struct Pizza: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let details: String
    let image: String
    let url: String
    let votes: Int
}

extension Pizza {
    var deeplink: URL {
        return URL(string: "\(Constants.deepLinkScheme)://deepdish.com?pizza=\(id)")!
    }
}
