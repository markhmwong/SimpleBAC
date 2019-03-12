//
//  GenderButton.swift
//  LastDrop
//
//  Created by Mark Wong on 26/8/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class GenderButton: BaseButton {
    
    override func setupButton() {
        super.setupButton()

        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: FontSingleton.sharedInstance.text)
        self.setTitleColor(FontConstants.Color.Button.Disabled, for: .normal)
        self.setTitleColor(FontConstants.Color.Button.Enabled, for: .selected)
        self.backgroundColor = UIColor.clear
        self.translatesAutoresizingMaskIntoConstraints = false
        
        //shadow
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 1.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10
        
    }
    
    func flashButton() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.tintColor = FontConstants.Color.Button.Enabled
        }, completion: { (_) in
            UIView.animate(withDuration: 0.2, delay: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.tintColor = FontConstants.Color.Button.Disabled
            }, completion: { (_) in
                
            })
        })
    }

}
