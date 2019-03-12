//
//  InfoView.swift
//  LastDrop
//
//  Created by Mark Wong on 8/10/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class InfoView: BaseView {
    
    let detailsView = UITextView()
    let closeButton = UIButton()
    var parentView: DetailsScreenView?
    
    override func setupViews() {
        
        self.backgroundColor = UIColor.clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = Theme.View.General.CornerRadius
        

        let attributesText = [NSAttributedStringKey.font: UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.disclaimer), NSAttributedStringKey.foregroundColor: FontConstants.Color.GlobalWhite]
        let attributesTitle = [NSAttributedStringKey.font: UIFont(name: FontConstants.StandardBold, size: FontSingleton.sharedInstance.disclaimer * 1.2), NSAttributedStringKey.foregroundColor: FontConstants.Color.GlobalWhite]

        let title = NSMutableAttributedString(string: "About\n\n", attributes: attributesTitle as [NSAttributedStringKey : Any])
        
        let attributedStr = title
        let contentOne = NSMutableAttributedString(string: "If you would like to have an exact measure of your current Blood Alcohol Content please use the nearest calibrated BAC tester. It is also possible to ask a local authority to have your BAC tested before you perform any task that requires 0 or a low BAC reading. This application is not responsible for or can be used as evidence under any circumstance to represent or to challenge your BAC level. This is to be used as a guide only.\n\n", attributes: attributesText as [NSAttributedStringKey : Any])
        attributedStr.append(contentOne)
        
        let attributesRuleOfThumb = [NSAttributedStringKey.font: UIFont(name: FontConstants.StandardBold, size: FontSingleton.sharedInstance.disclaimer), NSAttributedStringKey.foregroundColor: FontConstants.Color.GlobalWhite]
        let contentRuleOfThumb = NSMutableAttributedString(string: "Roughly as a rule of thumb, it is two drinks for the first hour and one drink per hour following. Regardless of the drink - wine, spirits, beer, one standard drink will always contain \(AlcoholicDrink.alcoholMass) grams of alcohol, depending on your location.\n\n", attributes: attributesRuleOfThumb as [NSAttributedStringKey : Any])
        attributedStr.append(contentRuleOfThumb)

        let contentCalculation = NSMutableAttributedString(string: "However, it may not apply to everyone as race, age, weight, food intake, water content, metabolism, gender and many other variables affect alcohol absorption. This application helps track how many drinks you've had while you can enjoy your night out without having too much thought.", attributes: attributesText as [NSAttributedStringKey : Any])
        attributedStr.append(contentCalculation)

        let contentCalculationTwo = NSMutableAttributedString(string: "This application's formula is based on the Widmark Formula. I've used it to help you track the time it will take to reach 0. Please drink responsibly.\n\n", attributes: attributesText as [NSAttributedStringKey : Any])
        attributedStr.append(contentCalculationTwo)

        let titlePrivacy = NSMutableAttributedString(string: "Privacy\n\n", attributes: attributesTitle as [NSAttributedStringKey : Any])
        attributedStr.append(titlePrivacy)
        
        let contentPrivacy = NSMutableAttributedString(string: "This application only keeps the entered information you have selected in the application locally (on the device) but may send the type of drink you entered.\n\n", attributes: attributesText as [NSAttributedStringKey : Any])
        attributedStr.append(contentPrivacy)
        
        
        detailsView.attributedText = attributedStr
        detailsView.isEditable = false
        detailsView.isUserInteractionEnabled = true
        detailsView.isScrollEnabled = true
        detailsView.showsVerticalScrollIndicator = false
        detailsView.backgroundColor = UIColor.clear
        detailsView.contentInset = UIEdgeInsets(top: 10, left: 7, bottom: 10, right: 7)
        self.addSubview(detailsView)
        
        closeButton.setTitle("Close", for: .normal)
        closeButton.backgroundColor = UIColor.clear
        closeButton.titleLabel?.font = UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.text)
        closeButton.addTarget(self, action: #selector(closeButtonHandler), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(closeButton)
        
    }
    
    @objc func closeButtonHandler(_ button: UIButton) {

        parentView?.handleModalView()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        detailsView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height * 0.9)
        closeButton.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        closeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
}
