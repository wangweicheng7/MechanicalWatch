//
//  ViewController.swift
//  Example
//
//  Created by weicheng wang on 2023/4/25.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let width = (NSScreen.main?.frame.width ?? 0)
        let height = (NSScreen.main?.frame.height ?? 0)
        
        let screenSaverView = MechanicalWatch(frame: CGRect(x: 0, y: 0, width: width, height: height), isPreview: true)
        screenSaverView?.autoresizingMask = [.width, .height]
        
        view.addSubview(screenSaverView!)
        screenSaverView?.startAnimation()
//
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//            screenSaverView?.animateOneFrame()
//        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

