//
//  Color+Extensions.swift
//  Live Pizza
//
//  Created by Vince Davis on 4/24/23.
//

import Foundation
import SwiftUI
import UIKit

extension UIColor {
    convenience init(
        light lightModeColor: @escaping @autoclosure () -> UIColor,
        dark darkModeColor: @escaping @autoclosure () -> UIColor
     ) {
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return lightModeColor()
            case .dark:
                return darkModeColor()
            case .unspecified:
                return lightModeColor()
            @unknown default:
                return lightModeColor()
            }
        }
    }
}

extension Color {
    init(
        light lightModeColor: @escaping @autoclosure () -> Color,
        dark darkModeColor: @escaping @autoclosure () -> Color
    ) {
        self.init(UIColor(
            light: UIColor(lightModeColor()),
            dark: UIColor(darkModeColor())
        ))
    }
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    init(_ hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }


    static var darkBrown: Color {
        return Color(0x48080E, alpha: 1.0)
    }

    static var mediumBrown: Color {
        return Color(0x864231, alpha: 1.0)
    }
    
    static var pizzaYellow: Color {
        return Color(0xEFD471, alpha: 1.0)
    }

    static var laBackgroundTop: Self {
        Self(light: Color(0xFFFFFF, alpha: 0.83),
             dark: Color(0x242424, alpha: 0.88))
    }

    static var laBottomText: Color {
        return Color(0xFFFFFF, alpha: 1.0)
    }

    static var laBackground: Color {
        Self(light: .pizzaYellow,
             dark: .darkBrown)
    }
    
    static var primaryText: Color {
        Self(light: .black,
             dark: .white)
    }
    
    static var leaderText: Color {
        Self(light: .mediumBrown,
             dark: .pizzaYellow)
    }
    
    static var secondaryText: Color {
        Self(light: Color(0x5A5A5A, alpha: 1.0),
             dark: .lightGray)
    }
    
    static var image: Color {
        Self(light: .mediumBrown,
             dark: .pizzaYellow)
    }
    
    static var progressGray: Color {
        Self(light: Color(0x555555, alpha: 0.77),
             dark: Color(0x878787, alpha: 1))
    }
    
    static var lightGray: Color {
        Self(light: Color(0x878787, alpha: 1),
             dark: Color(0x878787, alpha: 1))
    }
    
    static var dividerLine: Color {
        return Color(0x555555, alpha: 1.0)
    }
}

