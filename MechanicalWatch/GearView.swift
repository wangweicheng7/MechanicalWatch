//
//  GearView.swift
//  MechanicalWatch
//
//  Created by weicheng wang on 2023/4/23.
//

import Cocoa
import QuartzCore

class GearView: NSView {
    
    // 设定齿轮参数
    var innerRadius: CGFloat = 54.0
    var outerRadius: CGFloat = 60.0
    let numberOfTeeth = 30
    let toothWidthAngle: CGFloat = CGFloat.pi / 50
    var isClockwise = true
    
    var rotationAngle: CGFloat = 0.0
    
    lazy var shapeLayer: CAShapeLayer = {
        let clayer = CAShapeLayer()
        clayer.fillColor = NSColor.gray.withAlphaComponent(0.3).cgColor
        clayer.lineWidth = 2.0
        //        clayer.lineCap = .round
        //        clayer.lineJoin = .round
        clayer.strokeColor = NSColor.gray.cgColor//Configuration.shared.tintColor.cgColor
        clayer.autoreverses = true
        return clayer
    }()
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        setNeedsDisplay(bounds)
        layer?.backgroundColor = NSColor.clear.cgColor
        
        innerRadius = frame.width / 2 - 6
        outerRadius = frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func display(animation: Bool) {
        
        let gearCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        
        // 计算每个齿之间的角度
        let anglePerTooth = 2 * CGFloat.pi / CGFloat(numberOfTeeth)
        
        // 创建齿轮路径
        let gearPath = NSBezierPath()
        
        for i in 0..<numberOfTeeth {
            let toothStartAngle = CGFloat(i) * anglePerTooth
            let toothEndAngle = toothStartAngle + anglePerTooth
            
            let startPoint =  pointOnCircle(center: gearCenter, radius: innerRadius, angle: toothStartAngle + toothWidthAngle / 2)
            let outerPoint1 = pointOnCircle(center: gearCenter, radius: outerRadius, angle: toothStartAngle + toothWidthAngle)
            let outerPoint2 = pointOnCircle(center: gearCenter, radius: outerRadius, angle: toothEndAngle - toothWidthAngle)
            let endPoint =    pointOnCircle(center: gearCenter, radius: innerRadius, angle: toothEndAngle - toothWidthAngle / 2)
            
            if i == 0 {
                gearPath.move(to: startPoint)
            }else {
                gearPath.line(to: startPoint)
            }
            gearPath.line(to: outerPoint1)
            gearPath.line(to: outerPoint2)
            gearPath.line(to: endPoint)
            
        }
        
        

        
        // 添加一个圆形，需要镂空的部分
        let circleRadius: CGFloat = 10
        let circleRect = NSRect(x: gearCenter.x - circleRadius / 2,
                                y: gearCenter.y - circleRadius / 2,
                                width: circleRadius,
                                height: circleRadius)
        
        gearPath.appendOval(in: circleRect)
        
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
        
//        rotationAngle += isClockwise ? 1 : -1
        if rotationAngle >= 360 {
            rotationAngle = 0
        }
        
        let centerX = bounds.midX
        let centerY = bounds.midY
        let rotationTransform = CGAffineTransform(translationX: centerX, y: centerY)
            .rotated(by: rotationAngle * CGFloat.pi / 180)
            .translatedBy(x: -centerX, y: -centerY)
        
        shapeLayer.setAffineTransform(rotationTransform)
        
    }
    
    private func pointOnCircle(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        return CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
    }
}
