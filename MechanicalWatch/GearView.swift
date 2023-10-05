//
//  GearView.swift
//  MechanicalWatch
//
//  Created by weicheng wang on 2023/4/23.
//

import Cocoa
import QuartzCore

struct GearConfig {
    static let arcPerTooth: Double = 25   // 齿轮一个齿凹+凸的弦长，固定值
    static let timeInterval = Date().timeIntervalSince1970  // 启动时时间戳偏移常量
}

class GearView: NSView {
    
    // 设定齿轮参数
    var _innerRadius: CGFloat!      // 内半径，默认值
    var _outerRadius: CGFloat!      // 外半径，默认值
    
    private(set) var radianPerTooth: CGFloat!  // 齿轮每个齿的凹+凸角度为12°,齿数为 360/12 = 30
    private(set) var numberOfTeeth: Int!
    
    var _isClockwise = true
    
    var rotationAngle: CGFloat = 0.0
    var secondRadius: CGFloat = 0.0
    
    lazy var shapeLayer: CAShapeLayer = {
        let clayer = CAShapeLayer()
        clayer.fillColor = NSColor.gray.cgColor
        clayer.lineWidth = 2.0
        //        clayer.lineCap = .round
        //        clayer.lineJoin = .round
        clayer.strokeColor = NSColor.cyan.cgColor//Configuration.shared.tintColor.cgColor
        clayer.autoreverses = true
        return clayer
    }()
    
    convenience init(center: CGPoint, numberOfTeeth: Int, isClockwise: Bool) {
        let radius = GearConfig.arcPerTooth * Double(numberOfTeeth) / (2 * Double.pi)
        
        let rect = NSMakeRect(center.x - radius, center.y - radius, radius * 2, radius * 2)
        self.init(frame: rect)
        _outerRadius = radius
        _isClockwise = isClockwise
        self.numberOfTeeth = numberOfTeeth
        radianPerTooth = CGFloat.pi / 180 * CGFloat(360/numberOfTeeth)
        _innerRadius = _outerRadius - 10
        setNeedsDisplay(bounds)
        layer?.backgroundColor = NSColor.clear.cgColor
        
    }
    
    func display(animation: Bool) {
        
        let gearCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        
        
        // 计算每个齿之间的角度
        let anglePerTooth = 2 * CGFloat.pi / CGFloat(numberOfTeeth)
        
        // 创建齿轮路径
        let gearPath = NSBezierPath()
        
        for i in 0..<numberOfTeeth {
            let toothStartAngle = CGFloat(i) * anglePerTooth
            
            let startPoint =  pointOnCircle(center: gearCenter,
                                            radius: _innerRadius,
                                            angle: toothStartAngle)
            let outerPoint1 = pointOnCircle(center: gearCenter,
                                            radius: _outerRadius,
                                            angle: toothStartAngle + radianPerTooth/6)
            let outerPoint2 = pointOnCircle(center: gearCenter,
                                            radius: _outerRadius,
                                            angle: toothStartAngle + radianPerTooth/2)
            let endPoint =    pointOnCircle(center: gearCenter,
                                            radius: _innerRadius,
                                            angle: toothStartAngle + radianPerTooth / 6 * 4)
            
            if i == 0 {
                gearPath.move(to: startPoint)
            }else {
                gearPath.line(to: startPoint)
            }
            gearPath.line(to: outerPoint1)
            gearPath.line(to: outerPoint2)
            gearPath.line(to: endPoint)
            
        }
        gearPath.close()
        
        
        // 添加齿轮轴心
        let circleRadius: CGFloat = 10
        let circleRect = NSRect(x: gearCenter.x - circleRadius / 2,
                                y: gearCenter.y - circleRadius / 2,
                                width: circleRadius,
                                height: circleRadius)
        gearPath.appendOval(in: circleRect)
        
        // 添加镂空的部分
        if _innerRadius > 90 {
            let outRadius = _innerRadius - 30
            let inRadius: CGFloat = 30
            let solidWidth: CGFloat = 15
            let anglePerHollow = 36 - 90 * solidWidth / (Double.pi * outRadius) // 外圈每个镂空圆心角
            let anglePerHollow2 = 36 - 90 * solidWidth / (Double.pi * inRadius) // 内圈每个镂空圆心角
            
            for i in 0..<5 {
                
                
                let axisAngle =  Double(72 * i)
                let startAngle = (-anglePerHollow + axisAngle)  * Double.pi / 180
                let startPoint = NSPoint(x: gearCenter.x + outRadius * cos(startAngle),
                                         y: gearCenter.y + outRadius * sin(startAngle))
                gearPath.move(to: startPoint)
                gearPath.appendArc(withCenter: gearCenter, radius: outRadius, startAngle: axisAngle - anglePerHollow, endAngle: anglePerHollow + axisAngle, clockwise: false)
                gearPath.appendArc(withCenter: gearCenter, radius: inRadius, startAngle: anglePerHollow2 + axisAngle, endAngle: axisAngle - anglePerHollow2, clockwise: true)
                gearPath.line(to: startPoint)
            }
            layer?.backgroundColor = NSColor.black.withAlphaComponent(0.7).cgColor
        }else {
            shapeLayer.fillColor = NSColor.black.cgColor
        }
        
        // 设置填充规则为 evenOdd
        gearPath.windingRule = .evenOdd
        
        // 关联 layer 和贝塞尔路径
        shapeLayer.path = gearPath.cgPath
        shapeLayer.fillRule = .evenOdd
        wantsLayer = true
        layer?.addSublayer(shapeLayer)
        
        // 创建 Animation
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.fromValue = 0.0
        anim.toValue = 1.0
        anim.duration = 10.0
        
        if animation {
            // 设置 layer 的 animation
            shapeLayer.add(anim, forKey: nil)
            
        }
    }
    
    func updateRotation() {
        let _rotationAngle = _isClockwise ? rotationAngle : -rotationAngle
        
        let centerX = bounds.midX
        let centerY = bounds.midY
        let rotationTransform = CGAffineTransform(translationX: centerX, y: centerY)
            .rotated(by: _rotationAngle * CGFloat.pi / 180)
            .translatedBy(x: -centerX, y: -centerY)
        
        shapeLayer.setAffineTransform(rotationTransform)
        
    }
    
    private func pointOnCircle(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        return CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
    }
}
