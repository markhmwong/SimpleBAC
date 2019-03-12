//
//  DrinkButton.swift
//  LastDrop
//
//  Created by Mark Wong on 2/9/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class AddDrinkButton: BaseButton {
    
    let nameLabel = UILabel(frame: .zero)
    
    override func setupButton() {
        self.backgroundColor = UIColor.black
        
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.width / 2
    }
    
}
