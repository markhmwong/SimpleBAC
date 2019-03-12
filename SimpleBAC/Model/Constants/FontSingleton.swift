//
//  FontSingleton.swift
//  SimpleBAC
//
//  Created by Mark Wong on 21/10/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class FontSingleton {
    static let sharedInstance = FontSingleton()
    let ratioFrom8ToX: CGFloat = 0.82
    var mainResult: CGFloat = 60.0
    var text: CGFloat = 20.0
    var subtitle: CGFloat = 30.0
    var disclaimer: CGFloat = 12.0
    
    private init() {
        
    }
    
    func configureFontSize() -> Void {
        // older devices using the iphone 6 screen
        if (Device.TheCurrentDeviceHeight == DeviceHeight.iphone8) {
            mainResult = convertToLowerResolution(ratioFrom8ToX, mainResult)
            text = convertToLowerResolution(ratioFrom8ToX, text)
            subtitle = convertToLowerResolution(ratioFrom8ToX, subtitle)
            disclaimer = 11.0
        }
    }
    
    //type is the font we are targetting
    // ratio - initially made for the iPhone X, that was my hardware device at the time. 667 (iphone 8) / 812 (iphone X) will give us 0.82
    func convertToLowerResolution(_ ratio: CGFloat, _ type: CGFloat) -> CGFloat {
        return type * ratio
    }
    
}
