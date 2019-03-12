//
//  WhatsNewViewCell.swift
//  SimpleBAC
//
//  Created by Mark Wong on 10/10/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class WhatsNewViewCell: BaseCell {
    var title = UILabel()
    var content = UITextView()
    var animationView = UIView()
    
    override func setupView() {
        
        self.title.backgroundColor = UIColor.clear
        self.title.translatesAutoresizingMaskIntoConstraints = false
        self.title.textAlignment = .left
        self.addSubview(title)
        
        self.animationView.backgroundColor = UIColor.clear
        self.animationView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(animationView)
        
        self.content.isEditable = false
        self.content.backgroundColor = UIColor.clear
        self.content.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(content)
    }
    
    override func layoutSubviews() {
        self.title.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.title.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        self.title.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        
        self.animationView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.animationView.topAnchor.constraint(equalTo: self.title.bottomAnchor, constant: 20).isActive = true
        self.animationView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3).isActive = true
        self.animationView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        
        self.content.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.content.topAnchor.constraint(equalTo: self.animationView.bottomAnchor, constant: 30).isActive = true
        self.content.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        self.content.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4).isActive = true
        
        
    }
}
