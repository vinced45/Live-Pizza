//
//  Line.swift
//  Live Pizza
//
//  Created by Vince Davis on 4/24/23.
//

import SwiftUI
import Foundation

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        let start = CGPoint(x: rect.minX, y: rect.midY)
        let end = CGPoint(x: rect.maxX, y: rect.midY)

        return Path { p in
            p.move(to: start)
            p.addLine(to: end)
        }
    }
}
