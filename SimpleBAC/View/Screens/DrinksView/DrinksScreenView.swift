//
//  DrinksScreeView.swift
//  LastDrop
//
//  Created by Mark Wong on 28/8/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

enum CycleResults: Int, CaseIterable {
    case BACRemaining = 0
    case TimeRemaining
    case TotalBAC
//    case TimeSinceLastDrink
}

@objc protocol DrinksScreenProtocol {
    @objc optional func checkClockState()
}

class DrinksScreenView: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate  {
    var resultLabel: ResultsTextView = ResultsTextView()
    var bacTitle:CATextLayer?
    var mainViewController: LastDropRootViewController? = nil
    var addDrinksButton:UIButton = UIButton()
    let StartedAlready: BaseButton = BaseButton()

    var pathValuesArr:[CGPath] = []
    var sineWave:SineWaveShape!
    var dismissDrinkMenuView: UIView = UIView()
    
    let addDrinkView = UIView()
    let liquidShapeLayer = CAShapeLayer()
    var drinksModelArray: [DrinkCellModel] = []
    let blurView = UIVisualEffectView()

    //Ruler
    let rulerView = UIView()
    
    var cycleNumber: Int = 0
    var bacRemaining: NSAttributedString?
    var timeRemaining: NSAttributedString?
    var resultsLabelArr: [NSMutableAttributedString] = []
    
    var summaryText: NSMutableAttributedString?
    var timeRemainingText: NSMutableAttributedString?
    var summaryTextView = UITextView()

    lazy var drinkMenuCollView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.isScrollEnabled = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: addDrinkView.frame.width, height: addDrinkView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: drinksModelArray[indexPath.item].cellId, for: indexPath) as! DrinkSelectionCell
        cell.drinkViewDelegate = self
        cell.drinkData = drinksModelArray[indexPath.item]
        cell.addButton.tag = indexPath.item
        cell.mainViewController = mainViewController
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //Drinks to sselect from
    func setupDrinkModels() {
        let wine = DrinkCellModel(cellId: "WineDrinkCellId", name: "", alcohol: AlcoholicDrink.alcoholMass, color: UIColor.purple)
        drinksModelArray.append(wine)

    }
    
    override func setupView() {
        super.setupView()
        
        dismissDrinkMenuView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        dismissDrinkMenuView.backgroundColor = UIColor.clear
        self.addSubview(dismissDrinkMenuView)
        let escapeDrinkMenuTap = UILongPressGestureRecognizer(target: self, action: #selector(escapeDrinkMenuTapHandler))
        dismissDrinkMenuView.addGestureRecognizer(escapeDrinkMenuTap)
        
        self.setupDrinkModels()
        self.backgroundColor = Indian.CellViewBackground
        addDrinksButton.setTitle("Add a Drink", for: .normal)
        addDrinksButton.titleLabel?.font = UIFont(name: FontConstants.StandardBold, size: FontSingleton.sharedInstance.text)
        addDrinksButton.setTitleColor(FontConstants.Color.GlobalWhite, for: .normal)
        addDrinksButton.backgroundColor = UIColor.clear
        addDrinksButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addDrinksButton)
        addDrinksButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        addDrinksButton.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.18).isActive = true
        addDrinksButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.frame.height / 14).isActive = true
        addDrinksButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        addDrinksButton.addTarget(self, action: #selector(addDrinksButtonHandler), for: .touchUpInside)

        UIView.animate(withDuration: 0.8, delay: 0, options: [.repeat, .curveEaseInOut, .autoreverse, .allowUserInteraction], animations: {
            self.addDrinksButton.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }) { (_) in
            //
        }
        
        let stockAttributes = [NSAttributedStringKey.font: UIFont(name: FontConstants.StandardBold, size: FontSingleton.sharedInstance.mainResult * 0.6), NSAttributedStringKey.foregroundColor: FontConstants.Color.Global]
        
        let randomMessageStr = RandomOpeningMessage()
        summaryTextView.backgroundColor = UIColor.clear
        summaryTextView.attributedText = NSMutableAttributedString(string: randomMessageStr.pickRandomString(), attributes: stockAttributes as [NSAttributedStringKey : Any])
        summaryTextView.isEditable = false
        summaryTextView.isSelectable = false
        summaryTextView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(summaryTextView)
        summaryTextView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        summaryTextView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        summaryTextView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        summaryTextView.heightAnchor.constraint(equalToConstant: self.bounds.height * 0.7).isActive = true
        self.drawGlass()
        
        
        // cycling through stats
        //        let resultAttributes = [NSAttributedStringKey.font: UIFont(name: FontConstants.StandardBold, size: FontSingleton.sharedInstance.mainResult * 0.6), NSAttributedStringKey.foregroundColor: FontConstants.Color.Global]
        
        //        let attributedStr = NSMutableAttributedString(string: "0.000", attributes: resultAttributes as [NSAttributedStringKey : Any])
        //        resultLabel.attributedText = attributedStr
        //
        //        resultLabel.backgroundColor = UIColor.clear
        //        resultLabel.textAlignment = .right
        //
        //        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        //        let resultGesture = UITapGestureRecognizer(target: self, action: #selector(resultHandler))
        //        resultLabel.addGestureRecognizer(resultGesture)
        //        self.addSubview(resultLabel)
        //
        //        resultLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        //        resultLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        //        resultLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        //        resultLabel.heightAnchor.constraint(equalToConstant: self.bounds.height * 0.2).isActive = true
        
        //You've had <1 standard drink> at <starting time>
        //leading to a 0.02BAC. It'll take <time to 0> to reach 0
        //You've had 1 standard drink. You're at 0.02BAC. It'll take 3 hours to reach 0.
        
        
        
        
        //        let summaryHighlightAttribute = [NSAttributedStringKey.font: UIFont(name: FontConstants.StandardBold, size: FontSingleton.sharedInstance.mainResult * 0.6), NSAttributedStringKey.foregroundColor: UIColor.orange]
        //        let randomMessageStr = RandomOpeningMessage()
        //
        //        let startingText = NSMutableAttributedString(string: randomMessageStr.pickRandomString(), attributes: stockAttributes as [NSAttributedStringKey : Any])
        //
        //        summaryText = NSMutableAttributedString(string: "You've had ", attributes: stockAttributes as [NSAttributedStringKey : Any])
        //        let standardDrinkAndTimeAttributedStr = NSMutableAttributedString(string: "1 standard drink at 1:00pm. ", attributes: summaryHighlightAttribute as [NSAttributedStringKey : Any])
        //        summaryText?.append(standardDrinkAndTimeAttributedStr)
        //        let stockTextB = NSMutableAttributedString(string: "Currently at ", attributes: stockAttributes as [NSAttributedStringKey : Any])
        //        summaryText?.append(stockTextB)
        //        let bacAttributedStr = NSMutableAttributedString(string: "0.02 BAC. ", attributes: summaryHighlightAttribute as [NSAttributedStringKey : Any])
        //        summaryText?.append(bacAttributedStr)
        //        let stockTextC = NSMutableAttributedString(string: "It'll take ", attributes: stockAttributes as [NSAttributedStringKey : Any])
        //        summaryText?.append(stockTextC)
        //        timeRemainingText = NSMutableAttributedString(string: "3 hours ", attributes: summaryHighlightAttribute as [NSAttributedStringKey : Any])
        //        summaryText?.append(timeRemainingText ?? NSMutableAttributedString(string: "unknown time", attributes: summaryHighlightAttribute as [NSAttributedStringKey : Any]))
        //        let stockTextD = NSMutableAttributedString(string: "to reach 0.", attributes: stockAttributes as [NSAttributedStringKey : Any])
        //        summaryText?.append(stockTextD)
    }
    
    @objc func resultHandler() {
        
        let clockState = mainViewController?.clockState
        if (ClockState.Running == clockState && resultsLabelArr.count != 0) {
            //cycles through different results
            cycleNumber = cycleNumber + 1
            
            //reset count
            if (cycleNumber == CycleResults.allCases.count) {
                cycleNumber = 0
            }
            
            if (resultsLabelArr.count != 0) {
                switch cycleNumber {
                case CycleResults.BACRemaining.rawValue:
                    let attributedStr = resultsLabelArr[cycleNumber]
                    let resultAttributes:[NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.disclaimer)!, NSAttributedStringKey.foregroundColor: FontConstants.Color.Global]
                    let str = "LIMIT \(AlcoholicDrink.limit)"
                    let attStr = NSMutableAttributedString(string: "\n\(str)", attributes: resultAttributes)
                    attributedStr.append(attStr)
                    resultLabel.attributedText = attributedStr
                    break
                case CycleResults.TimeRemaining.rawValue:
                    let attributedStr = resultsLabelArr[cycleNumber]
                    let resultAttributes:[NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.disclaimer)!, NSAttributedStringKey.foregroundColor: FontConstants.Color.Global]
                    let str = "TIME TILL ZERO"
                    let attStr = NSMutableAttributedString(string: "\n\(str)", attributes: resultAttributes)
                    attributedStr.append(attStr)
                    resultLabel.attributedText = attributedStr
                    break
                case CycleResults.TotalBAC.rawValue:
                    let attributedStr = resultsLabelArr[cycleNumber]
                    let resultAttributes:[NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.disclaimer)!, NSAttributedStringKey.foregroundColor: FontConstants.Color.Global]
                    let str = "TOTAL BAC"
                    let attStr = NSMutableAttributedString(string: "\n\(str)", attributes: resultAttributes)
                    attributedStr.append(attStr)
                    resultLabel.attributedText = attributedStr
                    break
                default:
                    print("default")
                }
            }
        }
    }
    
    func updateResult(results: [NSMutableAttributedString]) {
        resultsLabelArr = results
        switch cycleNumber {
        case CycleResults.BACRemaining.rawValue:
            let attributedStr = resultsLabelArr[cycleNumber]
            let resultAttributes:[NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.disclaimer)!, NSAttributedStringKey.foregroundColor: FontConstants.Color.Global]
            let str = "LIMIT \(AlcoholicDrink.limit)"
            let attStr = NSMutableAttributedString(string: "\n\(str)", attributes: resultAttributes)
            attributedStr.append(attStr)
            resultLabel.textAlignment = .right
            resultLabel.attributedText = attributedStr
            break
        case CycleResults.TimeRemaining.rawValue:
            let attributedStr = resultsLabelArr[cycleNumber]
            let resultAttributes:[NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.disclaimer)!, NSAttributedStringKey.foregroundColor: FontConstants.Color.Global]
            let str = "TIME TILL ZERO"
            let attStr = NSMutableAttributedString(string: "\n\(str)", attributes: resultAttributes)
            attributedStr.append(attStr)
            resultLabel.attributedText = attributedStr
            break
        case CycleResults.TotalBAC.rawValue:
            let attributedStr = resultsLabelArr[cycleNumber]
            let resultAttributes:[NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.disclaimer)!, NSAttributedStringKey.foregroundColor: FontConstants.Color.Global]
            let str = "TOTAL BAC"
            let attStr = NSMutableAttributedString(string: "\n\(str)", attributes: resultAttributes)
            attributedStr.append(attStr)
            resultLabel.attributedText = attributedStr
            break
        default:
            print("default")
        }
    }
    
    func bacIndicatorTitleUpdateYPosition(newYPos: CGFloat) {
        
        bacTitle?.removeAnimation(forKey: "bacTitleYPosition")
        let sineWavePosAnimation = CAKeyframeAnimation(keyPath: "position.y")
        sineWavePosAnimation.duration = 4
        sineWavePosAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        sineWavePosAnimation.fillMode = kCAFillModeForwards
        sineWavePosAnimation.repeatCount = 1
        sineWavePosAnimation.isRemovedOnCompletion = false
        if let y = self.bacTitle?.position.y {
            sineWavePosAnimation.values = [y, newYPos]
        }
        bacTitle?.add(sineWavePosAnimation, forKey: "bacTitleYPosition")
    }
    
    func drawGlass() {
        _ = { () -> (width: CGFloat, height: CGFloat, xPos: CGFloat, yPos: CGFloat) in
            let width = self.frame.width * 0.45
            let height = self.frame.height * 0.4
            let xPos = self.frame.width * 0.5
            let yPos = self.frame.height * 0.3
            return (width, height, xPos, yPos)
        }
        
        addDrinkView.frame = CGRect(x: self.frame.width * 0.5 - (self.frame.width * 0.8 / 2), y: self.frame.height * 0.15, width: self.frame.width * 0.8, height: self.frame.height * 0.8)
        addDrinkView.backgroundColor = UIColor.clear
        addDrinkView.alpha = 0
        addDrinkView.layer.backgroundColor = UIColor.clear.cgColor
        addDrinkView.isOpaque = false
        addDrinkView.layer.cornerRadius = 30.0
        addDrinkView.clipsToBounds = true
        
        // Collection View For Drinks
        drinkMenuCollView.frame = CGRect(x: 0, y: 0, width: addDrinkView.bounds.width, height: addDrinkView.bounds.height)
        drinkMenuCollView.isPagingEnabled = true
        drinkMenuCollView.alpha = 1
        addDrinkView.addSubview(drinkMenuCollView)
        drinkMenuCollView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        for drink in drinksModelArray {
            drinkMenuCollView.register(DrinkSelectionCell.self, forCellWithReuseIdentifier: drink.cellId)
        }
    }

    func setupSineWave() {
        let stepAmplitude: Float = 1.0
        let maxAmplitude: Float = 9.0
        let minAmplitude: Float = 6.0
        sineWave = SineWaveShape(width:self.bounds.width, height:self.bounds.height)
        sineWave.prevYPos = self.bounds.height
        for amp in stride(from: minAmplitude, through: maxAmplitude, by: stepAmplitude) {
            self.sineWave.setupMainPoints(amp: amp)
            self.layer.insertSublayer(self.sineWave, at: 0)
        }
        
        for amp in stride(from: maxAmplitude, through: minAmplitude, by: -stepAmplitude) {
            self.sineWave.setupMainPoints(amp: amp)
            self.layer.insertSublayer(self.sineWave, at: 0)
        }
//        self.sineWave.position = CGPoint(x:0, y:self.frame.height)
//        self.sineWave.setupAnimation()
        
//        self.sineWave.startAnimation()
//        self.setupIndicators()
//        self.sineWave.updateYPosition(newYPos: newYPos)

        let newYPos = self.frame.height
        self.bacIndicatorTitleUpdateYPosition(newYPos: newYPos)
    }
    
    @objc func addDrinksButtonHandler(_ sender: AnyObject) {
        guard let settings = CoreDataHandler.fetchSettingsEntity() else {
            mainViewController?.scrollToSettings()
            return
        }
        
        guard let gender = settings.gender else {
            mainViewController?.scrollToSettings()
            return
        }
        
        if (gender != "") {
            self.handleDrinkView()
        }
        else {
            mainViewController?.scrollToSettings()
        }
    }
    
    @objc func escapeDrinkMenuTapHandler(_ longPressGesture: UILongPressGestureRecognizer) {
        
        if (longPressGesture.state == UIGestureRecognizerState.began || longPressGesture.state == UIGestureRecognizerState.changed)
        {
//            print("longpress began")
        }
        else if (longPressGesture.state == UIGestureRecognizerState.ended) {
//            print("long press ended")
        }
        
        if (self.addDrinkView.alpha == 1) {
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                self.addDrinkView.alpha = 0
                //Add Drink show
                self.addDrinksButton.alpha = 1
            }) { (_) in
                
            }
        }
    }
    
    func handleDrinkView() {
        if (self.addDrinkView.alpha == 0) {
            blurView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
            self.addSubview(blurView)
            self.addSubview(addDrinkView)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                self.addDrinkView.alpha = 1
                self.blurView.effect = UIBlurEffect(style: .dark)
                self.mainViewController?.collView.isScrollEnabled = false
                self.mainViewController?.menuBar.alpha = 0
                //Remove Add Drink Button
                self.addDrinksButton.alpha = 0
            }) { (_) in
                
            }
        }
        else {
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                self.addDrinkView.alpha = 0
                //Add Drink show
                self.addDrinksButton.alpha = 1
                self.mainViewController?.collView.isScrollEnabled = true
                self.mainViewController?.menuBar.alpha = 1
                self.blurView.effect = nil
                
            }) { (_) in
                self.blurView.removeFromSuperview()
                self.addDrinkView.removeFromSuperview()
            }
        }    
    }
    
    func isValidData() -> Bool {
        
        guard let drinkObjs: [DrinkStats] = CoreDataHandler.fetchDrinkEntity() else {
            return false
        }
        
        if (drinkObjs.count >= 0) {
            
            for d in drinkObjs {
                if (d.drinks < 0) {
                    return false
                }
                
                guard d.startTime != nil else {
                    return false
                }
                
//                guard d.timeRemaining != nil else {
//                    return false
//                }
            }
            return true
        }
        
        return false
    }
}


