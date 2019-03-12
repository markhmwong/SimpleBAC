//
//  CupView.swift
//  LastDrop
//
//  Created by Mark Wong on 3/10/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class CupView: UIVisualEffectView {
    let shapeLayerMask = CAShapeLayer()
    let liquidShapeLayer = CAShapeLayer()
    var parentCellView: DrinkSelectionCell?
    let generator = UIImpactFeedbackGenerator(style: .medium)

    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.setupViews()
    }
    
    func setupViews() {
        let roundedRectPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), cornerRadius: 20)

        self.alpha = 1
        self.isUserInteractionEnabled = true
        shapeLayerMask.path = roundedRectPath.cgPath
        self.contentView.layer.mask = shapeLayerMask
        self.effect = UIBlurEffect(style: .dark)


        let fillerPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        liquidShapeLayer.frame = self.bounds
        liquidShapeLayer.path = fillerPath.cgPath
        liquidShapeLayer.fillColor = FontConstants.Color.Cup.FillColor.cgColor
        self.contentView.layer.addSublayer(liquidShapeLayer)
        
        let rotation = 180.0 * (CGFloat.pi / 180)
        self.transform = CGAffineTransform(rotationAngle: rotation)
                
        let halfLine = CAShapeLayer()
        halfLine.frame = CGRect(x: self.bounds.width / 2 - (self.bounds.width / 4), y: self.bounds.height / 2, width: self.frame.width, height: 2)
        let linePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: halfLine.frame.width * 0.5, height: halfLine.frame.height), cornerRadius: 0)
        halfLine.path = linePath.cgPath
        halfLine.fillColor = UIColor.white.cgColor
        halfLine.opacity = 0.7
        self.contentView.layer.addSublayer(halfLine)
        
        let firstQuarter = CAShapeLayer()
        firstQuarter.frame = CGRect(x: self.bounds.width / 2 - (self.bounds.width / 8), y: self.bounds.height * 0.25, width: self.bounds.width / 2, height: 1)
        let quarterLinePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: firstQuarter.frame.width * 0.5, height: firstQuarter.frame.height), cornerRadius: 0)
        firstQuarter.path = quarterLinePath.cgPath
        firstQuarter.fillColor = UIColor.white.cgColor
        firstQuarter.opacity = 0.7
        self.contentView.layer.addSublayer(firstQuarter)
        
        let thirdQuarter = CAShapeLayer()
        thirdQuarter.frame = CGRect(x: self.bounds.width / 2 - (self.bounds.width / 8), y: self.bounds.height * 0.75, width: self.bounds.width / 2, height: 1)
        thirdQuarter.path = quarterLinePath.cgPath
        thirdQuarter.fillColor = UIColor.white.cgColor
        thirdQuarter.opacity = 0.7
        self.contentView.layer.addSublayer(thirdQuarter)
        
        let gesturePan = UIPanGestureRecognizer(target: self, action: #selector(self.handleCupMeasurement))
        self.contentView.addGestureRecognizer(gesturePan)
        
        generator.prepare()
    }
    
    func percentage(_ locationY: CGFloat, _ maxHeight: CGFloat) -> CGFloat {
        let result = (locationY / maxHeight) * 2
        return (result * 100).rounded(.toNearestOrAwayFromZero) / 100
    }
    
    @objc func handleCupMeasurement(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        if let maxHeight = shapeLayerMask.path?.boundingBox.height {
            if (location.y >= 0 && location.y <= maxHeight) {

                parentCellView?.realTimePercentageOfCup = percentage(location.y, maxHeight)

                if (parentCellView?.realTimePercentageOfCup.truncatingRemainder(dividingBy: 0.5) == 0) {
                    generator.impactOccurred()
                }
                
                let fillerPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.bounds.width, height: location.y))
                liquidShapeLayer.path = fillerPath.cgPath
                gesture.setTranslation(.zero, in: self)
            }            
        }
    }
    
}
