//
//  NSImage+Ex.swift
//  MechanicalWatch
//
//  Created by weicheng wang on 2023/4/29.
//

import Cocoa

extension NSImage {
    
    convenience init?(withName: String) {
        guard let path = Bundle(identifier: "com.weicheng.Example")?.pathForImageResource(withName) else {
            return nil
        }
        let url = URL(fileURLWithPath: path)
        self.init(contentsOf: url)
    }
}
