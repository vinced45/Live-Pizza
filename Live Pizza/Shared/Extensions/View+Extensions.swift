//
//  View+Extensions.swift
//  Live Pizza
//
//  Created by Vince Davis on 4/24/23.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    func foregroundColor(
        light lightModeColor: Color,
        dark darkModeColor: Color
    ) -> some View {
        modifier(AdaptiveForegroundColorModifier(
            lightModeColor: lightModeColor,
            darkModeColor: darkModeColor
        ))
    }
}
