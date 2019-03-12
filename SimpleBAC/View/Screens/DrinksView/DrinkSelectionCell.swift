//
//  DrinkType.swift
//  LastDrop
//
//  Created by Mark Wong on 27/9/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class DrinkSelectionCell: BaseCell, UIGestureRecognizerDelegate {
    var drinkData: DrinkCellModel?
    private let name = UILabel()
    let titleAttributes:[NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.subtitle)!, NSAttributedStringKey.foregroundColor: FontConstants.Color.GlobalWhite]
    var addButton = BaseButton()
    var closeButton = BaseButton()
    var drinkViewDelegate: DrinksScreenView?
    var mainViewController: LastDropRootViewController?
    let cupView = CupView(effect: UIBlurEffect(style: .dark))
    let parentCupView = UIView()

    var percentageOfCup: Float = 0.0
    var willAddBac = UILabel()
    var realTimePercentageOfCup: CGFloat = 0.0 {
        didSet {
            let resultAttributes:[NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.text)!, NSAttributedStringKey.foregroundColor: FontConstants.Color.Global]
            var str = ""
            if (realTimePercentageOfCup > 1) {
                str = "\(self.realTimePercentageOfCup) Std Drinks"
            }
            else {
                str = "\(self.realTimePercentageOfCup) Std Drink"
            }
            let attributedStr = NSAttributedString(string: "\(str)", attributes: resultAttributes)
            possibleBacLabel.attributedText = attributedStr
            let bacAttributedStr = NSAttributedString(string: "@ \(self.calculateBacFromCup(self.realTimePercentageOfCup)) BAC", attributes: resultAttributes)
            willAddBac.attributedText = bacAttributedStr
        }
    }
    var possibleBacLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drinkData = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func calculateBacFromCup(_ percentage: CGFloat) -> String {
        guard let settings = CoreDataHandler.fetchSettingsEntity() else {
            return "0.0"
        }
        guard let gender = settings.gender else {
            return "0.0"
        }
        
        let drink = AlcoholicDrink(weightInKgs: settings.weight, gender: gender, percentageOfDrinkConsumed: Float(percentage))
        drink.calculateBAC()
        
        return "\((drink.bac * 1000).rounded(.toNearestOrAwayFromZero) / 1000)"
    }
    
    override func setupView() {
        super.setupView()
        self.backgroundColor = UIColor.clear
        self.layer.opacity = 0.0

//        name.attributedText = NSAttributedString(string: "", attributes: titleAttributes)
//        name.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(name)
        
        possibleBacLabel.translatesAutoresizingMaskIntoConstraints = false
        possibleBacLabel.textAlignment = .center
        let resultAttributes:[NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.text)!, NSAttributedStringKey.foregroundColor: FontConstants.Color.Global]
        let attributedStr = NSAttributedString(string: "2.00 Std Drinks", attributes: resultAttributes)
        possibleBacLabel.attributedText = attributedStr
        self.addSubview(possibleBacLabel)
        self.possibleBacLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        self.possibleBacLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true

        let willAddBacAttributedStr = NSAttributedString(string: "@ \(self.calculateBacFromCup(2.00)) BAC", attributes: resultAttributes)
        willAddBac.attributedText = willAddBacAttributedStr
        willAddBac.translatesAutoresizingMaskIntoConstraints = false
        willAddBac.textAlignment = .center

        self.addSubview(willAddBac)
        self.willAddBac.topAnchor.constraint(equalTo: self.possibleBacLabel.bottomAnchor, constant: 30).isActive = true
        self.willAddBac.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        addButton.setAttributedTitle(NSAttributedString(string: "Add", attributes: [NSAttributedStringKey.font: UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.text)!, NSAttributedStringKey.foregroundColor: FontConstants.Color.GlobalWhite]), for: .normal)
        addButton.setTitleColor(UIColor.purple, for: .selected)
        addButton.backgroundColor = UIColor.clear
        addButton.layer.borderColor = FontConstants.Color.Button.Enabled.cgColor
        addButton.layer.borderWidth = Theme.View.Button.BorderWidth
        addButton.layer.cornerRadius = 25
        addButton.contentEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addDrinkHandler), for: .touchDown)
        self.addSubview(addButton)
        
        closeButton.setAttributedTitle(NSAttributedString(string: "Close", attributes: [NSAttributedStringKey.font: UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.text)!, NSAttributedStringKey.foregroundColor: FontConstants.Color.Button.Muted]), for: .normal)
        closeButton.setTitleColor(UIColor.white, for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeDrinkHandler), for: .touchDown)
        self.addSubview(closeButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        
        let cupViewRect = { () -> (width: CGFloat, height: CGFloat, xPos: CGFloat, yPos: CGFloat) in
            let width = self.frame.width * 0.45
            let height = self.frame.height * 0.50
            let xPos = self.frame.width * 0.5
            let yPos = self.frame.height * 0.3
            return (width, height, xPos, yPos)
        }
        parentCupView.frame = CGRect(x: self.frame.width * 0.5 - (cupViewRect().width / 2), y: possibleBacLabel.frame.origin.y + possibleBacLabel.bounds.height + 60, width: cupViewRect().width, height: cupViewRect().height)
        parentCupView.layer.cornerRadius = 20
        parentCupView.clipsToBounds = true
        self.addSubview(parentCupView)
        
        cupView.frame = CGRect(x: 0, y: 0, width: parentCupView.frame.width, height: parentCupView.frame.height)
        cupView.contentView.clipsToBounds = true
        cupView.parentCellView = self
        parentCupView.addSubview(cupView)
        if drinkData != nil {

            addButton.topAnchor.constraint(equalTo: cupView.bottomAnchor, constant: 30).isActive = true
            addButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
            addButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
            
            closeButton.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 30).isActive = true
            closeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        }
        else {
            print("no data")
        }
    }
    
    @objc func addDrinkHandler(_ button: UIButton) {
        guard let currHeight = cupView.liquidShapeLayer.path?.boundingBox.height else {
            return
        }

        guard let maxHeight = cupView.shapeLayerMask.path?.boundingBox.height else {
            return
        }
        
        guard let mvc = mainViewController else {
            return
        }
        
        let percentage: CGFloat = cupView.percentage(currHeight, maxHeight)
        
        self.recordDrink(percentage: Float(percentage))

        if (mvc.clockState == ClockState.Stop) {
            mvc.timerStateHandler(state: ClockState.Start)
        }
        
        drinkViewDelegate?.addDrinksButtonHandler(button)
    }
    
    @objc func closeDrinkHandler(_ button:UIButton) {
        drinkViewDelegate?.addDrinksButtonHandler(button) //closes the view
    }
    
    func recordDrink(percentage: Float) {
        let settings = CoreDataHandler.fetchSettingsEntity()
        
        guard let gender = settings?.gender else {
            return
        }
        
        guard let weight = settings?.weight else {
            return
        }
        
        if let drinkArr = CoreDataHandler.fetchDrinkEntity() {
            if (drinkArr.count == 0) {
                //1st drink
                let drink = AlcoholicDrink(weightInKgs: weight, gender: gender, percentageOfDrinkConsumed: percentage)
                drink.calculateAllStats()
                CoreDataHandler.saveAlcoholicDrink(alcoholicDrink: drink)
                mainViewController?.addToTotalStandardDrinks(percentage)
                mainViewController?.currentTime()
            }
            else {
                //subsequent drinks
                
                let mostRecentDrink = drinkArr[drinkArr.count - 1]
                guard let mostRecentDrinkDate = mostRecentDrink.startTime else {
                    return
                }
                let mostRecentDrinkStandardDrink = mostRecentDrink.drinks
                let recentDrink = AlcoholicDrink(weightInKgs: weight, gender: gender, percentageOfDrinkConsumed: mostRecentDrinkStandardDrink)
                
                recentDrink.calculateTimeRemaining()
                let newDate = mostRecentDrinkDate.addingTimeInterval(TimeInterval(recentDrink.timeRemainingInSeconds))
                
                let newDrink = AlcoholicDrink(weightInKgs: weight, gender: gender, percentageOfDrinkConsumed: percentage)
                newDrink.startingTime = newDate as Date
                
                CoreDataHandler.saveAlcoholicDrink(alcoholicDrink: newDrink)
                mainViewController?.addToTotalStandardDrinks(percentage)
            }
        }
    }
}
