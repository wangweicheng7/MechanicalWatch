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
        
        let screenSaverView = MechanicalWatchView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), isPreview: true)
        screenSaverView?.autoresizingMask = [.width, .height]
        
        view.addSubview(screenSaverView!)
        screenSaverView?.startAnimation()
        
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
            screenSaverView?.animateOneFrame()
        }
        
//        self.Sundial = [[Sundial alloc] initWithFrame:CGRectMake(0, 30, self.view.bounds.size.width, self.view.bounds.size.height - 30) isPreview:YES];
//        [self.Sundial setAutoresizingMask:NSViewHeightSizable|NSViewWidthSizable];
//        [self.view addSubview:self.Sundial];
//        [self.Sundial startAnimation];
//
//        [NSTimer scheduledTimerWithTimeInterval:0.25 repeats:YES block:^(NSTimer * _Nonnull timer) {
//            [self.Sundial animateOneFrame];
//        }];
//
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

