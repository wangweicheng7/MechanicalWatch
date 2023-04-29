//
//  NSBezierPath+Quartz.swift
//  MechanicalWatch
//
//  Created by weicheng wang on 2023/4/23.
//

import Cocoa

extension NSBezierPath {
    var cgPath: CGPath {
        let numElements = elementCount
        if numElements > 0 {
            let path = CGMutablePath()
            var didClosePath = true
            var points = [NSPoint](repeating: .zero, count: 3)
            
            for i in 0..<numElements {
                switch element(at: i, associatedPoints: &points) {
                case .moveTo:
                    path.move(to: CGPoint(x: points[0].x, y: points[0].y))
                case .lineTo:
                    path.addLine(to: CGPoint(x: points[0].x, y: points[0].y))
                    didClosePath = false
                case .curveTo:
                    path.addCurve(to: CGPoint(x: points[2].x, y: points[2].y),
                                  control1: CGPoint(x: points[0].x, y: points[0].y),
                                  control2: CGPoint(x: points[1].x, y: points[1].y))
                    didClosePath = false
                case .closePath:
                    path.closeSubpath()
                    didClosePath = true
                @unknown default:
                    fatalError("Unknown path element")
                }
            }
            
            if !didClosePath {
                path.closeSubpath()
            }
            
            return path
        } else {
            return CGPath(rect: .zero, transform: nil)
        }
    }
}
