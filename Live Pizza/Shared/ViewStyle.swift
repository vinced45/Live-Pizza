//
//  ViewStyle.swift
//  Live Pizza
//
//  Created by Vince Davis on 4/23/23.
//

import Foundation
import SwiftUI

enum ViewStyle {
    case liveActivity
    case dynamicIsland
    case siri
    case inApp
    
    var backgroundColor: Color {
        switch self {
        case .siri: return .clear
        default: return .white
        }
    }
    
    var offset: CGFloat {
        switch self {
        case .dynamicIsland: return -10
        default: return 0
        }
    }
}
