//
//  WhatsNewView.swift
//  SimpleBAC
//
//  Created by Mark Wong on 10/10/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class WhatsNewView: BaseView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let featuresView = UITextView()
//    let blurView = UIVisualEffectView()
    let cellId = "WhatsNew"
    var featureTitleAttributedStringArr: [NSMutableAttributedString] = []
    var featureContentAttributedStringArr: [NSMutableAttributedString] = []
    var featureAnimationViewArr: [UIView] = []

    var horizontalHighlightBar = UIView()
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    var countryTimer: Timer?
    var statsTimer: Timer?
    var statsArr: [NSMutableAttributedString] = []
    var statsLabel = UILabel()
    
    let countryTextLabel = UILabel()
    let countryArr = ["Australia", "Austria", "Canada", "Denmark", "Finland", "France", "Germany", "Hong Kong", "Hungary", "Iceland", "Ireland", "Italy", "Japan", "Netherlands", "Poland", "Portugal", "Spain", "Switzerland", "United Kingdom", "United States"]
    
    let okayButton = UIButton()
    
    var mainViewController: LastDropRootViewController?
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / CGFloat(featureTitleAttributedStringArr.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return featureContentAttributedStringArr.count
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collView.contentOffset
        visibleRect.size = collView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = collView.indexPathForItem(at: visiblePoint) else {
            return
        }
        
        //controls the animation in the first cell
        if (indexPath.item == 0) {
            if (statsTimer == nil) {
                statsTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateStats), userInfo: nil, repeats: true)
            }
            else if (statsTimer?.isValid == false) {
                statsTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateStats), userInfo: nil, repeats: true)
            }
            
        }
        else if (indexPath.item == 2 || indexPath.item == 1) {
            statsTimer?.invalidate()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! WhatsNewViewCell
        cell.backgroundColor = UIColor.clear
        cell.title.attributedText = featureTitleAttributedStringArr[indexPath.item]
        cell.content.attributedText = featureContentAttributedStringArr[indexPath.item]
        let resultAttributes = [NSAttributedStringKey.font: UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.mainResult * 0.5), NSAttributedStringKey.foregroundColor: FontConstants.Color.Global]

        if (indexPath.item == 0) {
            let attributedStrA = NSMutableAttributedString(string: "0.014", attributes: resultAttributes as [NSAttributedStringKey : Any])

            statsLabel.attributedText = attributedStrA
            statsLabel.backgroundColor = UIColor.clear
            statsLabel.textColor = FontConstants.Color.GlobalWhite
            cell.animationView.addSubview(statsLabel)
            statsLabel.translatesAutoresizingMaskIntoConstraints = false
            statsLabel.centerXAnchor.constraint(equalTo: cell.animationView.centerXAnchor).isActive = true
            statsLabel.centerYAnchor.constraint(equalTo: cell.animationView.centerYAnchor).isActive = true


            let timeAttributes:[NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.disclaimer)!, NSAttributedStringKey.foregroundColor: FontConstants.Color.GlobalWhite]

            let attributedStrB  = NSMutableAttributedString(string: "01", attributes: resultAttributes as [NSAttributedStringKey : Any])
            let hourTitleAttString = NSMutableAttributedString(string: "HRS", attributes: timeAttributes)
            attributedStrB.append(hourTitleAttString)
            
            let minAttString = NSMutableAttributedString(string: "40", attributes: resultAttributes as [NSAttributedStringKey : Any])
            attributedStrB.append(minAttString)
            let minTitleAttString = NSMutableAttributedString(string: "MINS", attributes: timeAttributes)
            attributedStrB.append(minTitleAttString)
            
            let secAttString = NSMutableAttributedString(string: "56", attributes: resultAttributes as [NSAttributedStringKey : Any])
            attributedStrB.append(secAttString)
            let secTitleAttString = NSMutableAttributedString(string: "SECS", attributes: timeAttributes)
            attributedStrB.append(secTitleAttString)

            let attributedStrC = NSMutableAttributedString(string: "1.4 std drinks", attributes: resultAttributes as [NSAttributedStringKey : Any])

            statsArr.append(attributedStrA)
            statsArr.append(attributedStrB)
            statsArr.append(attributedStrC)
        }
            
        else if (indexPath.item == 1) {
            let attributedStrC = NSMutableAttributedString(string: "Australia", attributes: resultAttributes as [NSAttributedStringKey : Any])
            
            countryTextLabel.attributedText = attributedStrC
            countryTextLabel.alpha = 1
            cell.animationView.addSubview(countryTextLabel)
            countryTextLabel.translatesAutoresizingMaskIntoConstraints = false
            countryTextLabel.centerXAnchor.constraint(equalTo: cell.animationView.centerXAnchor).isActive = true
            countryTextLabel.centerYAnchor.constraint(equalTo: cell.animationView.centerYAnchor).isActive = true
            countryTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCountryAnimation), userInfo: nil, repeats: true)

        }
        else if (indexPath.item == 2) {
            let textC = UILabel()
            let resultAttributesC = [NSAttributedStringKey.font: UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.mainResult), NSAttributedStringKey.foregroundColor: FontConstants.Color.GlobalWhite]

            let attributedStrC = NSMutableAttributedString(string: "🍻", attributes: resultAttributesC as [NSAttributedStringKey : Any])
            textC.attributedText = attributedStrC
            textC.backgroundColor = UIColor.clear
            textC.textColor = FontConstants.Color.GlobalWhite
            cell.animationView.addSubview(textC)
            textC.translatesAutoresizingMaskIntoConstraints = false
            textC.centerXAnchor.constraint(equalTo: cell.animationView.centerXAnchor).isActive = true
            textC.centerYAnchor.constraint(equalTo: cell.animationView.centerYAnchor).isActive = true
            
            okayButton.setTitle("Cheers!", for: .normal)
            okayButton.setTitleColor(UIColor.white, for: .normal)
            okayButton.addTarget(self, action: #selector(endWhatsNewTour), for: .touchUpInside)
            okayButton.titleLabel?.font = UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.text)
            okayButton.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(okayButton)
            
            okayButton.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -20).isActive = true
            okayButton.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.width, height: self.bounds.height)
    }
    
    lazy var collView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        return view
    }()
    var countryIndex = 0
    @objc func updateCountryAnimation() {
        
        let resultAttributes = [NSAttributedStringKey.font: UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.mainResult * 0.5), NSAttributedStringKey.foregroundColor: FontConstants.Color.Global]


        if (countryIndex <= countryArr.count - 1) {
            countryTextLabel.fadeTransition(0.8)
            let attributedStrC = NSMutableAttributedString(string: countryArr[countryIndex], attributes: resultAttributes as [NSAttributedStringKey : Any])
            countryTextLabel.attributedText = attributedStrC
            countryIndex += 1
        }
        else {
            countryIndex = 0
        }
    }
    var statsIndex = 0
    @objc func updateStats() {
        
        if (statsIndex <= statsArr.count - 1) {
            statsLabel.fadeTransition(0.8)
            statsLabel.attributedText = statsArr[statsIndex]
            statsIndex += 1
        }
        else {
            statsIndex = 0

        }
        
    }
    
    override func setupViews() {
        self.setupFeatures()

        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
        
        collView.backgroundColor = UIColor.clear
        collView.isPagingEnabled = true
        collView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(collView)
        collView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        collView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1)
        
        collView.register(WhatsNewViewCell.self, forCellWithReuseIdentifier: cellId)
        
        horizontalHighlightBar.backgroundColor = UIColor.white
        horizontalHighlightBar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(horizontalHighlightBar)
        
        horizontalHighlightBar.heightAnchor.constraint(equalToConstant: 6).isActive = true
        horizontalHighlightBar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalHighlightBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1 / CGFloat(featureTitleAttributedStringArr.count)).isActive = true
        horizontalBarLeftAnchorConstraint = horizontalHighlightBar.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
    }
    
    @objc func endWhatsNewTour () {
        mainViewController?.removeWhatsNewView()
    }
    
    func setupTitles() {
        let attributesTitle = [NSAttributedStringKey.font: UIFont(name: FontConstants.StandardBold, size: FontSingleton.sharedInstance.disclaimer * 2), NSAttributedStringKey.foregroundColor: FontConstants.Color.GlobalWhite]
        let featureATitle = NSMutableAttributedString(string: "Welcome", attributes: attributesTitle as [NSAttributedStringKey : Any])
        featureTitleAttributedStringArr.append(featureATitle)
        let featureBTitle = NSMutableAttributedString(string: "Legal Limit", attributes: attributesTitle as [NSAttributedStringKey : Any])
        featureTitleAttributedStringArr.append(featureBTitle)
        let featureCTitle = NSMutableAttributedString(string: "Cheers To You", attributes: attributesTitle as [NSAttributedStringKey : Any])
        featureTitleAttributedStringArr.append(featureCTitle)
    }
    
    func setupContent() {
        let attributesText = [NSAttributedStringKey.font: UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.disclaimer), NSAttributedStringKey.foregroundColor: FontConstants.Color.GlobalWhite]
        
        let featureAContent = NSMutableAttributedString(string: "Helpful and clear statistics shows the BAC remaining, the time remaining to reach zero BAC and total standard drinks consumed.", attributes: attributesText as [NSAttributedStringKey : Any])
        featureContentAttributedStringArr.append(featureAContent)
        
        let featureBContent = NSMutableAttributedString(string: "A standard drink is defined by the country. This means a standard drink from Australia could be dfiferent from a standard drink in Canada. Currently 20 countries are supported, with their data defined by the World Health Organisation.", attributes: attributesText as [NSAttributedStringKey : Any])
        featureContentAttributedStringArr.append(featureBContent)
        
        let featureCContent = NSMutableAttributedString(string: "Remember to enjoy yourself and your time out. Drink responsibly, look after each other and drive safe.", attributes: attributesText as [NSAttributedStringKey : Any])
        featureContentAttributedStringArr.append(featureCContent)
    }
    
    func setupAnimation() {
        let featureAView = UIView()
        
        let textA = UILabel()
        textA.text = "0.05"
        textA.backgroundColor = UIColor.red
        textA.textColor = UIColor.yellow
        featureAView.addSubview(textA)
        let textB = UILabel()
        textB.text = "0.6"
        featureAView.translatesAutoresizingMaskIntoConstraints = false
        featureAView.addSubview(textB)
        featureAView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        featureAView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        featureAnimationViewArr.append(featureAView)
        let featureBView = UIView()
        featureAnimationViewArr.append(featureBView)
        let featureCView = UIView()
        featureAnimationViewArr.append(featureCView)
    }
    
    func setupFeatures() -> Void {
        self.setupTitles()
        self.setupContent()
    }
    
    override func layoutSubviews() {
        featuresView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
    }
    
}

extension UIView
{
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionFade)
    }
}
