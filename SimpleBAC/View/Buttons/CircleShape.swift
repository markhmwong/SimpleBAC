//
//  CircleShape.swift
//  LastDrop
//
//  Created by Mark Wong on 31/8/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class CircleShape: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        //check rect because it doesn't seem to alter
        let center: CGPoint = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius: Double = Double(rect.width) / 10 //here adjust size
        
        let path = UIBezierPath()
        path.lineWidth = 2
        path.move(to: CGPoint(x: center.x + CGFloat(radius), y: center.y))
        
        for i in stride(from: 0, to: 361.0,  by: 10) {
            
            let radians = i * Double.pi / 180
            
            let x = Double(center.x) + radius * cos(radians)
            let y = Double(center.y) + radius * sin(radians)
            
            path.addLine(to: CGPoint(x: x, y: y))
        }
        UIColor.white.setFill()
        UIColor.white.setStroke()
        path.fill()
        path.stroke()
    }
    
    
}
