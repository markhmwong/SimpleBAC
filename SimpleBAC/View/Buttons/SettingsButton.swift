//
//  SettingsButton.swift
//  LastDrop
//
//  Created by Mark Wong on 31/8/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class SettingsButton: BaseButton {
    /*
        Needs work
     */
    override func setupButton() {
        let circleWidth = self.frame.size.width / 3
        let circleHeight = self.frame.size.height / 3
        let circleTop = CircleShape(frame: CGRect(x: 0, y: 0, width: circleWidth, height: circleHeight))
//        circleTop.translatesAutoresizingMaskIntoConstraints = false
//        circleTop.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
//        circleTop.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        circleTop.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.33).isActive = true
//        circleTop.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(circleTop)
        let circleMiddle = CircleShape(frame: CGRect(x: 0, y: 0, width: circleWidth, height: circleHeight))
//        self.addSubview(circleMiddle)
        let circleBottom = CircleShape(frame: CGRect(x: 0, y: 0, width: circleWidth, height: circleHeight))
//        self.addSubview(circleBottom)
        
        let stackView = UIStackView(arrangedSubviews: [circleTop, circleMiddle, circleBottom])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = UIColor.cyan
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
}
