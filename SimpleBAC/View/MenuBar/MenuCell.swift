//
//  MenuCell.swift
//  LastDrop
//
//  Created by Mark Wong on 19/8/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class MenuCell: BaseCell {
    
    var placeHolderLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func setupView() {
        super.setupView()
        
//        self.backgroundView = nil //not sure what this does
        self.backgroundColor = UIColor.clear
        
        placeHolderLabel.backgroundColor = UIColor.clear
        placeHolderLabel.textColor = UIColor.white
        placeHolderLabel.text = "MenuCell"
        placeHolderLabel.font = UIFont.boldSystemFont(ofSize: FontConstants.Size.MenuBar)
        placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(placeHolderLabel)
        
//        placeHolderLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        placeHolderLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
