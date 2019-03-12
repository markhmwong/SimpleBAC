//
//  DataLabel.swift
//  LastDrop
//
//  Created by Mark Wong on 27/8/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class DataLabel: BaseLabel {
    
    override func setupLabel() {
        self.text = "0.00"
        self.font = UIFont.init(name: FontConstants.Standard, size: FontSingleton.sharedInstance.text * 3)
        self.backgroundColor = UIColor.clear
        self.textColor = FontConstants.Color.Global
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
