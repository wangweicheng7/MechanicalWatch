//
//  MechanicalWatchView.swift
//  MechanicalWatchView
//
//  Created by weicheng wang on 2023/4/23.
//

import ScreenSaver

class MechanicalWatch: ScreenSaverView {
    
    lazy var watchDialView: WatchDialView = {
        var size = (NSScreen.main?.frame.width ?? 0) / 3
        size = size < 516 ? 516 : size
        var x = (NSScreen.main?.frame.width ?? 0) / 4
        let y = (NSScreen.main?.frame.height ?? 0) / 2
        
        let w = WatchDialView(frame: NSRect(x: x - size/2, y: y - size/2, width: size, height: size))
        w.translatesAutoresizingMaskIntoConstraints = false
        return w
    }()
    
    lazy var watchDialView2: WatchDialView = {
        var size = (NSScreen.main?.frame.width ?? 0) / 3
        size = size < 516 ? 516 : size
        var x = (NSScreen.main?.frame.width ?? 0) / 4
        let y = (NSScreen.main?.frame.height ?? 0 - size) / 2
        let w = WatchDialView(frame: NSRect(x: x * 3 - size/2, y: y - size / 2, width: size, height: size))
        w.translatesAutoresizingMaskIntoConstraints = false
        return w
    }()
    
    lazy var mainSpring: DoubleGearView = {
        var x = (NSScreen.main?.frame.width ?? 0) / 4
        let y = (NSScreen.main?.frame.height ?? 0) / 2
        let g = DoubleGearView(center: CGPoint(x: x + 192, y: y), numberOfTeeth1: 10, numberOfTeeth2: 40, isClockwise: true)
        return g
    }()
    
    lazy var centerWheel: GearView = {
        var x = (NSScreen.main?.frame.width ?? 0) / 4
        let y = (NSScreen.main?.frame.height ?? 0) / 2
        let g = GearView(center: CGPoint(x: x, y: y + 192), numberOfTeeth: 10, isClockwise: true)
        return g
    }()
    
    lazy var secondWheel: GearView = {
        var x = (NSScreen.main?.frame.width ?? 0) / 4
        let y = (NSScreen.main?.frame.height ?? 0) / 2
        let g = GearView(center: CGPoint(x: x, y: y), numberOfTeeth: 40, isClockwise: false)
        return g
    }()
    
    lazy var thirdWheel: GearView = {
        let g = GearView(center: CGPoint(x: 360, y: 60), numberOfTeeth: 30, isClockwise: true)
        return g
    }()
    
    lazy var escapementWheel: GearView = {
        let g = GearView(center: CGPoint(x: 410, y: 60), numberOfTeeth: 20, isClockwise: true)
        return g
    }()
    
    override init?(frame: CGRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        //        initializeScreenSaver()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //        initializeScreenSaver()
    }
    
    private func initializeScreenSaver() {
        layer?.backgroundColor = NSColor.white.cgColor
        
        wantsLayer = true
        
        // 将齿轮添加到屏保视图
        addSubview(mainSpring)
        addSubview(centerWheel)
        addSubview(secondWheel)
//        addSubview(thirdWheel)
//        addSubview(escapementWheel)
        
        // 将表盘视图添加到屏幕保护程序视图中
        addSubview(watchDialView)
//        addSubview(watchDialView2)
    }
    
    override func animateOneFrame() {
        super.animateOneFrame()
        let offset = Date().timeIntervalSince1970 - GearConfig.timeInterval
        
        mainSpring.rotationAngle = offset * 24 - 6 // 6: 两组齿轮咬合的偏移量
        
        centerWheel.rotationAngle = offset * 96
        
        secondWheel.rotationAngle = offset * 6
        thirdWheel.rotationAngle += 0.8
        escapementWheel.rotationAngle += 1.6
        
        mainSpring.updateRotation()
        centerWheel.updateRotation()
        secondWheel.updateRotation()
        thirdWheel.updateRotation()
        escapementWheel.updateRotation()
        
        watchDialView.updateHands()
        watchDialView2.updateHands()
    }
    
    override func startAnimation() {
        super.startAnimation()
        initializeScreenSaver()
        
        watchDialView.display(animation: true)
        watchDialView2.display(animation: true)
        // 设置齿轮之间的相互作用
        mainSpring.display(animation: true)
        centerWheel.display(animation: true)
        secondWheel.display(animation: true)
        thirdWheel.display(animation: true)
        escapementWheel.display(animation: true)
        
    }
}
