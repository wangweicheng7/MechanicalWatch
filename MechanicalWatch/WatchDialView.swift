//
//  WatchDialView.swift
//  MechanicalWatch
//
//  Created by weicheng wang on 2023/4/24.
//

import Cocoa

class WatchDialView: NSView {
    
    var _dialRadius: CGFloat = 0
    let _smallTickLength: CGFloat = 30.0
    let _largeTickLength: CGFloat = 60.0
    let _smallTickWidth: CGFloat = 2.0
    let _largeTickWidth: CGFloat = 6.0
    
    
    private var timer: Timer?
    
    var hourHand: WatchHandView!
    var minuteHand: WatchHandView!
    var secondHand: WatchHandView!
    
    lazy var shapeLayer: CAShapeLayer = {
        let clayer = CAShapeLayer()
        clayer.lineWidth = 5.0
        clayer.lineCap = .round
        clayer.lineJoin = .round
        clayer.strokeColor = NSColor.white.cgColor//Configuration.shared.tintColor.cgColor
        clayer.autoreverses = true
        return clayer
    }()
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        initaliz()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initaliz()
    }
    
    func initaliz(){
        
        _dialRadius = bounds.width < 516 ? 290 : bounds.width / 2
        
        hourHand = WatchHandView(frame: NSRect(x: bounds.width / 2 - 3, y: bounds.height/2, width: 6, height: 130),
                                 type: .hour)
        minuteHand = WatchHandView(frame: NSRect(x: bounds.width / 2 - 3, y: bounds.height/2, width: 6, height: 234),
                                   type: .minute)
        secondHand = WatchHandView(frame: NSRect(x: bounds.width / 2 - 10, y: bounds.height/2 - 32, width: 20, height: 290),
                                   type: .second)
        
        hourHand.setRotation(CGPoint.zero)
        minuteHand.setRotation(CGPoint.zero)
        secondHand.setRotation(CGPoint(x: 0, y: 32))
        
        addSubview(hourHand)
        addSubview(minuteHand)
        addSubview(secondHand)
        
        updateHands()
    }
    
    func display(animation: Bool) {
        let dialCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let numberOfTicks = 60
        let anglePerTick = 2 * CGFloat.pi / CGFloat(numberOfTicks)
        
        let dialPath = NSBezierPath()
        
        for i in 0..<numberOfTicks {
            let tickStartAngle = CGFloat(i) * anglePerTick
            
            let innerTickRadius: CGFloat
            
            if i % 5 == 0 {
                innerTickRadius = _dialRadius - _largeTickLength
            } else {
                innerTickRadius = _dialRadius - _smallTickLength
            }
            
            let startPoint = pointOnCircle(center: dialCenter, radius: innerTickRadius, angle: tickStartAngle)
            let endPoint = pointOnCircle(center: dialCenter, radius: _dialRadius, angle: tickStartAngle)
            
            dialPath.move(to: startPoint)
            dialPath.line(to: endPoint)
        }
        
        // 关联 layer 和贝塞尔路径
        shapeLayer.path = dialPath.cgPath
        shapeLayer.fillRule = .evenOdd
        wantsLayer = true
        layer?.addSublayer(shapeLayer)
        
        layer?.backgroundColor = NSColor.black.withAlphaComponent(0.7).cgColor
        layer?.cornerRadius = _dialRadius
        layer?.masksToBounds = true
        
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
    
    private func pointOnCircle(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        return CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
    }
    
    func updateHands() {
        let currentTime = Date()
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: currentTime) % 12
        let minute = calendar.component(.minute, from: currentTime)
        let second = calendar.component(.second, from: currentTime)
        
        let timeInterval = currentTime.timeIntervalSince1970
        let secondDecimal = Double(second) + timeInterval - Double(Int(timeInterval))    // 获取当前秒，小数点后保留毫秒
        let minuteDecimal = Double(minute) + (secondDecimal / 60)
        let hourDecimal = Double(hour) + minuteDecimal / 60
        
        let hourRotation = CGFloat(hourDecimal / 12.0 * 360.0)
        let minuteRotation = CGFloat(minuteDecimal / 60.0 * 360.0)
        let secondRotation = CGFloat(secondDecimal / 60.0 * 360.0)
        
        
        let rotationTransformH = CGAffineTransform(translationX: 3, y: 0)
            .rotated(by: -hourRotation * CGFloat.pi / 180)
            .translatedBy(x: -3, y: 0)
        
        let rotationTransformM = CGAffineTransform(translationX: 3, y: 0)
            .rotated(by: -minuteRotation * CGFloat.pi / 180)
            .translatedBy(x: -3, y: 0)
        
        let rotationTransformS = CGAffineTransform(translationX: 10, y: 32)
            .rotated(by: -secondRotation * CGFloat.pi / 180)
            .translatedBy(x: -10, y: -32)
        
        // 创建旋转变换并应用到视图的主层
        hourHand.layer?.setAffineTransform(rotationTransformH)
        minuteHand.layer?.setAffineTransform(rotationTransformM)
        secondHand.layer?.setAffineTransform(rotationTransformS)
    }
}

