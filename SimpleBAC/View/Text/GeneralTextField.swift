//
//  MyText.swift
//  LastDrop
//
//  Created by Mark Wong on 24/8/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class GeneralTextField: UITextField {
    override var tintColor: UIColor! {
        
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupText()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupText() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.keyboardType = UIKeyboardType.numberPad
        self.textAlignment = .center
        self.font = UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.text)
        self.backgroundColor = UIColor.clear

    }
    
    override func draw(_ rect: CGRect) {
        
        let startingPoint = CGPoint(x: rect.minX, y: rect.maxY)
        let endingPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        
        let path = UIBezierPath()
        
        path.move(to: startingPoint)
        path.addLine(to: endingPoint)
        path.lineWidth = 4.0
        
        tintColor.setStroke()
        
        path.stroke()
    }
    
}
