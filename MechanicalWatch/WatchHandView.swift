//
//  WatchHandView.swift
//  MechanicalWatch
//
//  Created by weicheng wang on 2023/4/24.
//

import Cocoa

enum HandType {
case hour, minute, second
}

class WatchHandView: NSView {
    
    private var color: NSColor = NSColor.clear
    
    lazy var handImageView: NSImageView = {
        let iv = NSImageView()
        return iv
    }()
    
//    override init(frame frameRect: NSRect) {
//        super.init(frame: frameRect)
//        let img = NSImage(withName: "ic_second_hand")
//        handImageView.image = img
//        layer?.backgroundColor = NSColor.red.cgColor
//        addSubview(handImageView)
//    }
    
    convenience init(frame frameRect: NSRect, type: HandType) {
        self.init(frame: frameRect)
        let iv = NSImageView(frame: NSMakeRect(0, 0, bounds.width, bounds.height))
        switch type {
        case .hour:
            iv.image = NSImage(withName: "ic_hour_hand")
        case .minute:
            iv.image = NSImage(withName: "ic_minute_hand")
        case .second:
            iv.image = NSImage(withName: "ic_second_hand")
        }
        
        addSubview(iv)
    }
    
    func setRotation(_ point: CGPoint) {
        // 设置锚点
        let oldOrigin = frame.origin
        
        // 设置锚点
        layer?.anchorPoint = CGPoint(x: (point.x - oldOrigin.x) / bounds.width, y: (point.y - oldOrigin.y) / bounds.height)
        layer?.position = point
    }
}
