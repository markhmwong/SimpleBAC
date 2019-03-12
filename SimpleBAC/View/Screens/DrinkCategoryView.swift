//
//  DrinkCategoryButton.swift
//  LastDrop
//
//  Created by Mark Wong on 18/9/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class DrinkMenuView: BaseView {
    
    var buttonOne: UIButton = UIButton()
    var buttonTwo: UIButton = UIButton()
    var buttonThree: UIButton = UIButton()
    var stackView: UIStackView = UIStackView()
    
    
    override func setupViews() {
        
        self.backgroundColor = UIColor.black
        
        buttonOne.backgroundColor = UIColor.green
        buttonOne.translatesAutoresizingMaskIntoConstraints = false
        buttonTwo.backgroundColor = UIColor.blue
        buttonTwo.translatesAutoresizingMaskIntoConstraints = false

        stackView = UIStackView(arrangedSubviews: [buttonOne, buttonTwo])
        self.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        

    }
    
    override func layoutSubviews() {
        //possibly making it crash here!
        
//        buttonOne.centerYAnchor.constraint(equalTo: stackView.centerYAnchor).isActive = true
//        buttonOne.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 10).isActive = true
//        buttonOne.widthAnchor.constraint(equalToConstant: self.frame.width / 4).isActive = true
//        buttonOne.heightAnchor.constraint(equalToConstant: self.frame.height * 0.7).isActive = true
//        
//        buttonTwo.centerYAnchor.constraint(equalTo: stackView.centerYAnchor).isActive = true
//        buttonTwo.leadingAnchor.constraint(equalTo: buttonOne.leadingAnchor, constant: 10).isActive = true
//        buttonTwo.widthAnchor.constraint(equalToConstant: self.frame.width / 4).isActive = true
//        buttonTwo.heightAnchor.constraint(equalToConstant: self.frame.height * 0.7).isActive = true
    }
}

