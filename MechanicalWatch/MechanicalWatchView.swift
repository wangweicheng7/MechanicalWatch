//
//  MechanicalWatchView.swift
//  MechanicalWatchView
//
//  Created by weicheng wang on 2023/4/23.
//

import ScreenSaver

class MechanicalWatchView: ScreenSaverView {
    
    lazy var watchDialView: WatchDialView = {
                let w = WatchDialView(frame: NSRect(x: 0, y: 0, width: 200, height: 200))
                w.translatesAutoresizingMaskIntoConstraints = false
        return w
    }()
    
    lazy var mainSpring: GearView = {
        let g = GearView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        return g
    }()
    
    lazy var centerWheel: GearView = {
        let g = GearView(frame: CGRect(x: 150, y: 0, width: 100, height: 100))
        return g
    }()
    
    lazy var secondWheel: GearView = {
        let g = GearView(frame: CGRect(x: 250, y: 0, width: 80, height: 80))
        return g
    }()
    
    lazy var thirdWheel: GearView = {
        let g = GearView(frame: CGRect(x: 330, y: 0, width: 60, height: 60))
        return g
    }()
    
    lazy var escapementWheel: GearView = {
        let g = GearView(frame: CGRect(x: 390, y: 0, width: 40, height: 40))
        return g
    }()
    
//    lazy var gearView: GearView = {
//        let g = GearView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
//        return g
//    }()
//
//    lazy var gearView2: GearView = {
//        let g = GearView(frame: CGRect(x: 114, y: 0, width: 120, height: 120))
//        g.rotationAngle = 5
//        g.updateRotation()
//        g.isClockwise = false
//        return g
//    }()
    
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
            addSubview(thirdWheel)
            addSubview(escapementWheel)
        
        
        // 将表盘视图添加到屏幕保护程序视图中
                addSubview(watchDialView)
        
        // 设置表盘视图的约束以居中
//        NSLayoutConstraint.activate([
//            gearView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            gearView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -57),
//        ])
//
//        NSLayoutConstraint.activate([
//            gearView2.centerXAnchor.constraint(equalTo: centerXAnchor),
//            gearView2.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 57)
//
//        ])
        
        NSLayoutConstraint.activate([
            watchDialView.centerXAnchor.constraint(equalTo: centerXAnchor),
            watchDialView.centerYAnchor.constraint(equalTo: centerYAnchor),
            watchDialView.widthAnchor.constraint(equalToConstant: 200),
            watchDialView.heightAnchor.constraint(equalToConstant: 200),
        ])
        
        
    }
    
    override func animateOneFrame() {
        super.animateOneFrame()
        
        mainSpring.rotationAngle += 0.1
                centerWheel.rotationAngle += 0.2
                secondWheel.rotationAngle += 0.4
                thirdWheel.rotationAngle += 0.8
                escapementWheel.rotationAngle += 1.6
        
        mainSpring.updateRotation()
                centerWheel.updateRotation()
                secondWheel.updateRotation()
                thirdWheel.updateRotation()
                escapementWheel.updateRotation()
        
        watchDialView.updateHands()
    }
    
    override func startAnimation() {
        super.startAnimation()
        initializeScreenSaver()
        
        watchDialView.display(animation: true)
        // 设置齿轮之间的相互作用
            mainSpring.display(animation: true)
            centerWheel.display(animation: true)
            secondWheel.display(animation: true)
            thirdWheel.display(animation: true)
            escapementWheel.display(animation: true)
        
    }
}
