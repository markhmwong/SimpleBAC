//
//  BaseLabel.swift
//  LastDrop
//
//  Created by Mark Wong on 27/8/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class BaseLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabel() {
        
    }
    
}
