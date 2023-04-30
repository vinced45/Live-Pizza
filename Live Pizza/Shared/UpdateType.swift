//
//  UpdateType.swift
//  Live Pizza
//
//  Created by Vince Davis on 4/26/23.
//

import Foundation

enum UpdateType: String, Codable {
    case cloud
    case device
    case refresh
    case siri
    
    var icon: String {
        switch self {
        case .cloud: return "cloud.fill"
        case .device: return "iphone"
        case .refresh: return "timer"
        case .siri: return "mic.fill"
        }
    }
}
