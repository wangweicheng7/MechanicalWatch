//
//  WatchDialView.swift
//  MechanicalWatch
//
//  Created by weicheng wang on 2023/4/24.
//

import Cocoa

class WatchDialView: NSView {
    
    let dialRadius: CGFloat = 100.0
    let smallTickLength: CGFloat = 5.0
    let largeTickLength: CGFloat = 15.0
    let smallTickWidth: CGFloat = 1.0
    let largeTickWidth: CGFloat = 2.0
    
    
    private var timer: Timer?
    
    var hourHand: WatchHandView!
    var minuteHand: WatchHandView!
    var secondHand: WatchHandView!
    
    lazy var shapeLayer: CAShapeLayer = {
        let clayer = CAShapeLayer()
        clayer.fillColor = NSColor.clear.cgColor
        clayer.lineWidth = 2.0
        //        clayer.lineCap = .round
        //        clayer.lineJoin = .round
        clayer.strokeColor = NSColor.gray.cgColor//Configuration.shared.tintColor.cgColor
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
        hourHand = WatchHandView(frame: NSRect(x: bounds.width / 2 - 3, y: bounds.height/2, width: 6, height: 60))
        minuteHand = WatchHandView(frame: NSRect(x: bounds.width / 2 - 2, y: bounds.height/2, width: 4, height: 80))
        secondHand = WatchHandView(frame: NSRect(x: bounds.width / 2 - 1, y: bounds.height/2 + 10, width: 2, height: 100))
        
        secondHand.setRotation(CGPoint(x: 50, y: 150))
        
        
        hourHand.display(animation: true)
        minuteHand.display(animation: true)
        secondHand.display(animation: true)
        
        addSubview(hourHand)
        addSubview(minuteHand)
        addSubview(secondHand)
        
        NSLayoutConstraint.activate([
            hourHand.centerXAnchor.constraint(equalTo: centerXAnchor),
            hourHand.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -hourHand.frame.height / 2),
            minuteHand.centerXAnchor.constraint(equalTo: centerXAnchor),
            minuteHand.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -minuteHand.frame.height / 2),
            secondHand.centerXAnchor.constraint(equalTo: centerXAnchor),
            secondHand.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -secondHand.frame.height / 2)
        ])

        
        updateHands()
//        startTimer()
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
                innerTickRadius = dialRadius - largeTickLength
            } else {
                innerTickRadius = dialRadius - smallTickLength
            }
            
            let startPoint = pointOnCircle(center: dialCenter, radius: innerTickRadius, angle: tickStartAngle)
            let endPoint = pointOnCircle(center: dialCenter, radius: dialRadius, angle: tickStartAngle)
            
            dialPath.move(to: startPoint)
            dialPath.line(to: endPoint)
        }
        
        // 关联 layer 和贝塞尔路径
        shapeLayer.path = dialPath.cgPath
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
    
    private func pointOnCircle(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        return CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
    }
    
    
    
    func updateHands() {
        let currentTime = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: currentTime) % 12
        let minute = calendar.component(.minute, from: currentTime)
        let second = calendar.component(.second, from: currentTime)
        
        let hourRotation = CGFloat(Double(hour) / 12.0 * 360.0)
        let minuteRotation = CGFloat(Double(minute) / 60.0 * 360.0)
        let secondRotation = CGFloat(Double(second) / 60.0 * 360.0)
        
        
        let rotationTransform = CGAffineTransform(translationX: 1, y: 10)
            .rotated(by: -secondRotation * CGFloat.pi / 180)
            .translatedBy(x: -1, y: -10)
//        secondHand.layer?.setAffineTransform(rotationTransform)
        
        hourHand.layer?.setAffineTransform(CGAffineTransform(rotationAngle: -hourRotation * CGFloat.pi / 180))
        
        // 创建旋转变换并应用到视图的主层
        minuteHand.layer?.setAffineTransform(CGAffineTransform(rotationAngle: -minuteRotation * CGFloat.pi / 180))
        secondHand.layer?.setAffineTransform(rotationTransform)
    }
    
//    private func startTimer() {
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
//            self?.updateHands()
//        }
//    }

//    private func stopTimer() {
//        timer?.invalidate()
//        timer = nil
//    }

//    deinit {
//        stopTimer()
//    }
}

