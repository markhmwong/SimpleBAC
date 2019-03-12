//
//  Button.swift
//  LastDrop
//
//  Created by Mark Wong on 26/8/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class BaseButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButton() {
        
    }
    
}
