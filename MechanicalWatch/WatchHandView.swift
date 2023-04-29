//
//  WatchHandView.swift
//  MechanicalWatch
//
//  Created by weicheng wang on 2023/4/24.
//

import Cocoa

class WatchHandView: NSView {
    
    private var color: NSColor = NSColor.clear
    
    lazy var shapeLayer: CAShapeLayer = {
        let clayer = CAShapeLayer()
        clayer.fillColor = color.cgColor
        clayer.lineWidth = 2.0
        //        clayer.lineCap = .round
        //        clayer.lineJoin = .round
        clayer.strokeColor = NSColor.red.cgColor//Configuration.shared.tintColor.cgColor
        clayer.autoreverses = true
        return clayer
    }()
    
    func display(animation: Bool) {
        
        wantsLayer = true
        
        let path = NSBezierPath()
        
        let startPoint = CGPoint(x: bounds.width/2, y: bounds.height)
        let point1 = CGPoint(x: 0, y: bounds.height * 0.2)
        let endPoint = CGPoint(x: bounds.width/2, y: 0)
        let point2 = CGPoint(x: bounds.width, y: bounds.height * 0.2)
        
        path.move(to: startPoint)
        path.line(to: point1)
        path.line(to: endPoint)
        path.line(to: point2)
        
        let centerX = bounds.midX - 10
        let centerY = bounds.midY - 10
        let rotation = CGFloat.pi / 2
        
        // Translate and rotate the context
        let transform = NSAffineTransform()
        transform.translateX(by: centerX, yBy: centerY)
        transform.rotate(byRadians: rotation)
        transform.translateX(by: -centerX, yBy: -centerY)
        transform.concat()
        
        
        // 关联 layer 和贝塞尔路径
        shapeLayer.path = path.cgPath
        shapeLayer.fillRule = .evenOdd
        wantsLayer = true
        layer?.addSublayer(shapeLayer)
        
        // 创建 Animation
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.fromValue = 0.0
        anim.toValue = 1.0
        anim.duration = 1.0
        
        if animation {
            // 设置 layer 的 animation
            shapeLayer.add(anim, forKey: nil)
        }
        
    }
    
    func setRotation(_ point: CGPoint) {
        // 设置锚点
        let oldOrigin = frame.origin
        
        print(oldOrigin)
        print(point)
        print(layer?.anchorPoint ?? CGPoint.zero)
        
        // 设置锚点
        layer?.anchorPoint = CGPoint(x: (point.x - oldOrigin.x) / bounds.width, y: (point.y - oldOrigin.y) / bounds.height)
        layer?.position = point
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }
    
}
