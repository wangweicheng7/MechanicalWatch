//
//  DoubleGearView.swift
//  MechanicalWatch
//
//  Created by weicheng wang on 2023/4/29.
//

import Cocoa

class DoubleGearView: NSView {

    // 设定齿轮参数
    var rotationAngle: CGFloat = 0.0
    var secondRadius: CGFloat = 0.0
    
    var _g1: GearView!
    var _g2: GearView!
    
    convenience init(center: CGPoint, numberOfTeeth1: Int, numberOfTeeth2: Int, isClockwise: Bool) {
        
        let radius = GearConfig.arcPerTooth * Double(max(numberOfTeeth1, numberOfTeeth2)) / (2 * Double.pi)
        let rect = NSMakeRect(center.x - radius, center.y - radius, radius * 2, radius * 2)
        
        self.init(frame: rect)
        
        let gearCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        _g1 = GearView(center: gearCenter, numberOfTeeth: numberOfTeeth1, isClockwise: isClockwise)
        _g2 = GearView(center: gearCenter, numberOfTeeth: numberOfTeeth2, isClockwise: isClockwise)
        
        setNeedsDisplay(bounds)
        layer?.backgroundColor = NSColor.clear.cgColor
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func display(animation: Bool) {
        
        addSubview(_g2)
        addSubview(_g1)
        
        _g1.display(animation: true)
        _g2.display(animation: true)
    }
    
    func updateRotation() {
        _g1.rotationAngle = rotationAngle
        _g2.rotationAngle = rotationAngle
        _g1.updateRotation()
        _g2.updateRotation()
    }
}
