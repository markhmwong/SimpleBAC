//
//  IndicatorTitle.swift
//  LastDrop
//
//  Created by Mark Wong on 13/9/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class IndicatorTitleLabel: BaseLabel {
    
    override func setupLabel() {
        self.font = UIFont.init(name: FontConstants.Standard, size: FontSingleton.sharedInstance.text * 0.5)
        self.backgroundColor = UIColor.clear
        self.textColor = FontConstants.Color.Global
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
