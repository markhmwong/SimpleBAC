//
//  SineWaveShape.swift
//  LastDrop
//
//  Created by Mark Wong on 12/9/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class SineWaveShape: CAShapeLayer, CAAnimationDelegate {
    
    var lambda:CGFloat = 0.0
    let stepAmplitude: Float = 1.0
    let maxAmplitude: Float = 8.0
    let minAmplitude: Float = 5.0
    var pointArr:[CGPoint] = []
    var origin:CGPoint = CGPoint(x: 0, y: 0)
    let lengthConst:CGFloat = 10.0
    var pathValuesArr:[CGPath] = []
    var height:CGFloat = 0
    var phaseShiftAnimation:CAKeyframeAnimation = CAKeyframeAnimation()
    var curveAnimation: CAKeyframeAnimation = CAKeyframeAnimation()
//    let animationGroup = CAAnimationGroup()

    var prevYPos: CGFloat = 0.0
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(width: CGFloat, height: CGFloat) {
        super.init()
        
        self.lambda = width * 2.0
        self.height = height
        self.setupShape()
    }
    
    func setupShape() {
        self.fillColor = UIColor.orange.cgColor
        self.strokeColor = UIColor.yellow.cgColor
        self.lineWidth = 0
    }
    
    func setupMainPoints(amp: Float) {
        pointArr = self.defineMainPoints(startPoint: origin, endPoint: CGPoint(x:lambda * lengthConst, y: origin.y), amplitude: CGFloat(amp))
        let quadPath = defineQuadPath(pointArr: pointArr)
        self.path = quadPath.cgPath
        self.position = CGPoint(x:0, y:self.frame.height / 2)
        pathValuesArr.append(quadPath.cgPath)
    }
    
    func setupAnimation() {
        curveAnimation = CAKeyframeAnimation(keyPath: "path")
        curveAnimation.values = pathValuesArr
        curveAnimation.duration = 4
        curveAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        curveAnimation.fillMode = kCAFillModeForwards
        curveAnimation.repeatCount = Float.infinity

        phaseShiftAnimation = CAKeyframeAnimation(keyPath: "position.x")
        phaseShiftAnimation.duration = 20
        phaseShiftAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        phaseShiftAnimation.fillMode = kCAFillModeForwards
        phaseShiftAnimation.repeatCount = Float.infinity
        phaseShiftAnimation.values = [self.position.x - lambda * 7, self.position.x - lambda]

    }
    
    func startAnimation() {
        self.add(curveAnimation, forKey: "amplitudeAnimation")
        self.add(phaseShiftAnimation, forKey: "phaseShiftAnimation")

    }
    
    var yPos: CGFloat = 0.0
    func updateYPositionForBac(newYPos: CGFloat) {
//        yPos = newYPos
//        let sineWavePosAnimation = CABasicAnimation(keyPath: "position.y")
//        sineWavePosAnimation.duration = 0.1
//        sineWavePosAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        sineWavePosAnimation.fillMode = kCAFillModeForwards
//        sineWavePosAnimation.repeatCount = 1
//        sineWavePosAnimation.isRemovedOnCompletion = false
//        sineWavePosAnimation.fromValue = prevYPos
//        sineWavePosAnimation.toValue = newYPos
//        sineWavePosAnimation.delegate = self
//        self.add(sineWavePosAnimation, forKey: "sineWavePositionShort")
        
//        if (self.animation(forKey: "sineWavePositionLong") == nil) {
//
//            if ((self.prevYPos - newYPos) > 100) {
//                //animation no longer exists
//                print("test")
//                sineWavePosAnimation.duration = 0.5
//                sineWavePosAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
//                sineWavePosAnimation.fillMode = kCAFillModeForwards
//                sineWavePosAnimation.repeatCount = 1
//                sineWavePosAnimation.isRemovedOnCompletion = false
//                sineWavePosAnimation.fromValue = prevYPos
//                sineWavePosAnimation.toValue = newYPos
//                sineWavePosAnimation.delegate = self
//                self.add(sineWavePosAnimation, forKey: "sineWavePositionLong")
////                animationGroup.animations?.append(sineWavePosAnimation)
//                prevYPos = newYPos
//            }
//            else {
//                print("test2")
//                sineWavePosAnimation.duration = 0.1
//                sineWavePosAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
//                sineWavePosAnimation.fillMode = kCAFillModeForwards
//                sineWavePosAnimation.repeatCount = 1
//                sineWavePosAnimation.isRemovedOnCompletion = false
//                sineWavePosAnimation.fromValue = prevYPos
//                sineWavePosAnimation.toValue = newYPos
//                self.add(sineWavePosAnimation, forKey: "sineWavePositionShort")
//                prevYPos = newYPos
//            }
//        }
        /*
         let sineWavePosAnimation = CAKeyframeAnimation(keyPath: "position.y")
         if (self.animation(forKey: "sineWavePositionLong") == nil) {
         
         if ((self.prevYPos - newYPos) > 100) {
         //animation no longer exists
         sineWavePosAnimation.duration = 2.5
         sineWavePosAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
         sineWavePosAnimation.fillMode = kCAFillModeBoth
         sineWavePosAnimation.repeatCount = 1
         sineWavePosAnimation.isRemovedOnCompletion = false
         sineWavePosAnimation.values = [prevYPos, newYPos]
         sineWavePosAnimation.delegate = self
         self.add(sineWavePosAnimation, forKey: "sineWavePositionLong")
         prevYPos = newYPos
         }
         else {
         sineWavePosAnimation.duration = 0.1
         sineWavePosAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
         sineWavePosAnimation.fillMode = kCAFillModeBoth
         sineWavePosAnimation.repeatCount = 1
         sineWavePosAnimation.isRemovedOnCompletion = false
         sineWavePosAnimation.values = [prevYPos, newYPos]
         self.add(sineWavePosAnimation, forKey: "sineWavePositionShort")
         prevYPos = newYPos
         }
         }
         */
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        self.position.y = yPos
//        self.removeAnimation(forKey: "sineWavePositionLong")
    }
    
    /*
     Midpoint - Calculates the mid point between to designated points
     */
    
    private func defineMidPoint(pointA: CGPoint, pointB: CGPoint) -> CGPoint {
        
        let midX = (pointA.x + pointB.x) / 2
        let midY = (pointA.y + pointB.y) / 2
        
        return CGPoint(x:midX, y:midY)
    }
    
    /*
     control points - calcultes the control point. in this case a control point is just another mid point. This helps furhter define the curvature of the path (smoother)
     */
    private func defineControlPoint(p1: CGPoint, p2: CGPoint) -> CGPoint {
        var point:CGPoint = defineMidPoint(pointA: p1, pointB: p2)
        let dy:CGFloat = abs(p2.y - point.y)
        
        if (p1.y < p2.y) {
            point.y += dy
        }
        else if (p1.y > p2.y) {
            point.y -= dy
        }
        return point
    }
    
    /*
     Draw bezier curve
     Works by obtaining the mid point of the mid point. e.g. p0 -> mid(0,1) -> p1. p0 -> mid(0, mid) -> mid
     */
    
    private func defineQuadPath(pointArr: [CGPoint]) -> UIBezierPath {
        let curvePath = UIBezierPath()
        
        curvePath.move(to: pointArr[0])
        var p1 = pointArr[0]
        for i in 1 ..< pointArr.count {
            //define mid point
            
            let p2 = pointArr[i]
            let midPoint = defineMidPoint(pointA: p1, pointB: p2)
            curvePath.addQuadCurve(to: midPoint, controlPoint: defineControlPoint(p1: midPoint, p2: p1))
            curvePath.addQuadCurve(to: p2, controlPoint: defineControlPoint(p1: midPoint, p2: p2))
            p1 = p2
        }
        
        curvePath.addLine(to: CGPoint(x: p1.x, y:height * 8))
        curvePath.addLine(to: CGPoint(x: 0, y:height * 8))
        curvePath.close()
        
        return curvePath
    }
    
    /*
     Calculates out the points between the start and end of one wavelength
     */
    private func defineMainPoints(startPoint: CGPoint, endPoint: CGPoint, amplitude: CGFloat) -> [CGPoint] {
        let step = self.lambda / 2
        var pointArr:[CGPoint] = []
        var tempAmp = amplitude
        
        for xPoint in stride(from: startPoint.x, through: endPoint.x, by: step) {
            let newPoint = CGPoint(x:xPoint, y: tempAmp)
            tempAmp = -tempAmp
            pointArr.append(newPoint)
        }
        return pointArr
    }
    
    override func setNeedsLayout() {
        print("shape layer update")
    }
    
}
