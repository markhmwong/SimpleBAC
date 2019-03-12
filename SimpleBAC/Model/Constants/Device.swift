//
//  Device.swift
//  SimpleBAC
//
//  Created by Mark Wong on 21/10/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

struct Device {
    
    static var TheCurrentDeviceHeight: CGFloat {
        struct Singleton {
            static let height = max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)
        }
        return Singleton.height
    }
}
