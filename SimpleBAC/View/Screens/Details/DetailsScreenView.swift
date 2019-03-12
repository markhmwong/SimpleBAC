//
//  HomeScreenView.swift
//  LastDrop
//
//  Created by Mark Wong on 20/8/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

enum GenderButtonTag {
    case Male
    case Female
}

class DetailsScreenView: BaseCell {
    let modalInfoView = InfoView()
    let blurView = UIVisualEffectView()
    var modalToggle:Bool = false
    let weightTitleLabel: UILabel = UILabel(frame: .zero)
    let genderTitleLabel: UILabel = UILabel(frame: .zero)
    var weightField: GeneralTextField = GeneralTextField(frame: .zero)
    var drinksField: GeneralTextField = GeneralTextField(frame: .zero)
    var maleButton: GenderButton = GenderButton(frame: .zero)
    var femaleButton: GenderButton = GenderButton(frame: .zero)
    var gender: String?
    
    var resetButton: UIButton = UIButton(frame: .zero)
    var saveButton: UIButton = UIButton(frame: .zero)
    var saveConfirmButton: UIButton = UIButton(frame: .zero)

    var homeScreenViewDelegate:DetailsScreenView?
    let genderStackView = UIStackView()

    var mainViewController: LastDropRootViewController?
    
    let locationLabel = UITextView()
    let setLocation = UIButton()
    let versionNumber = UILabel()
    
    override func setupView() {
        super.setupView()
        self.backgroundColor = Indian.CellViewBackground
        
        let attributes = [NSAttributedStringKey.font: UIFont(name: FontConstants.StandardBold, size: FontSingleton.sharedInstance.subtitle), NSAttributedStringKey.foregroundColor: FontConstants.Color.GlobalWhite]
        let weightAttributedStr = NSMutableAttributedString(string: "WEIGHT (Kg)", attributes: attributes as [NSAttributedStringKey : Any])

        weightTitleLabel.attributedText = weightAttributedStr
        weightTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(weightTitleLabel)
        
        weightTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: self.bounds.height * 0.12).isActive = true
        weightTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        
        weightField.placeholder = "Kg"
        weightField.textColor = FontConstants.Color.GlobalWhite
        self.addSubview(weightField)
        
        weightField.topAnchor.constraint(equalTo: weightTitleLabel.bottomAnchor, constant: 5).isActive = true
        weightField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        weightField.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.08).isActive = true
        weightField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        weightField.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        weightField.layer.shadowOffset = CGSize(width: 0, height: 3)
        weightField.layer.shadowOpacity = 1.0
        weightField.layer.shadowRadius = 5.0
        weightField.layer.masksToBounds = false
        weightField.tintColor = FontConstants.Color.Global
        
        maleButton.setTitle("Male", for: .normal)
        maleButton.tag = GenderButtonTag.Male.hashValue
        maleButton.addTarget(self, action: #selector(genderControl), for: .touchDown)
        
        femaleButton.setTitle("Female", for: .normal)
        femaleButton.tag = GenderButtonTag.Female.hashValue
        femaleButton.addTarget(self, action: #selector(genderControl), for: .touchDown)
        
        drinksField.placeholder = "Drinks"
        
        let genderAttributedStr = NSMutableAttributedString(string: "GENDER", attributes: attributes as [NSAttributedStringKey : Any])
        genderTitleLabel.attributedText = genderAttributedStr
        genderTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(genderTitleLabel)
        
        genderTitleLabel.topAnchor.constraint(equalTo: weightField.bottomAnchor, constant: 25).isActive = true
        genderTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        
        genderStackView.addArrangedSubview(maleButton)
        genderStackView.addArrangedSubview(femaleButton)

        genderStackView.axis = .horizontal
        genderStackView.distribution = .fillEqually
        self.addSubview(genderStackView)
        
        let inputSpacing:CGFloat = 5.0
        genderStackView.setCustomSpacing(inputSpacing, after: maleButton)
        genderStackView.translatesAutoresizingMaskIntoConstraints = false
        genderStackView.topAnchor.constraint(equalTo: genderTitleLabel.bottomAnchor, constant:inputSpacing).isActive = true
        genderStackView.leadingAnchor.constraint(equalTo: weightField.leadingAnchor).isActive = true
        genderStackView.trailingAnchor.constraint(equalTo: weightField.trailingAnchor).isActive = true
        genderStackView.heightAnchor.constraint(equalTo: weightField.heightAnchor, multiplier:1).isActive = true
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveControl), for: .touchDown)
        saveButton.titleLabel?.font = UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.text)
        saveButton.setTitleColor(FontConstants.Color.Button.Enabled, for: .normal)
        saveButton.setTitleColor(UIColor.purple, for: .selected)
        saveButton.backgroundColor = UIColor.clear
        saveButton.layer.borderColor = FontConstants.Color.Button.Enabled.cgColor
        saveButton.layer.borderWidth = 2
        saveButton.layer.cornerRadius = 25
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.contentEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0)
        self.addSubview(saveButton)
        
        saveButton.topAnchor.constraint(equalTo: genderStackView.bottomAnchor, constant: 150).isActive = true
        saveButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        saveConfirmButton.setTitle("Saved", for: .normal)
        saveConfirmButton.isUserInteractionEnabled = false
        saveConfirmButton.titleLabel?.font = UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.text)
        saveConfirmButton.setTitleColor(Indian.CellViewBackground, for: .normal)
        saveConfirmButton.setTitleColor(UIColor.purple, for: .selected)
        saveConfirmButton.backgroundColor = UIColor.white
        saveConfirmButton.layer.borderColor = FontConstants.Color.Button.Enabled.cgColor
        saveConfirmButton.layer.borderWidth = 2
        saveConfirmButton.layer.cornerRadius = 25
        saveConfirmButton.translatesAutoresizingMaskIntoConstraints = false
        saveConfirmButton.contentEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0)
        saveConfirmButton.alpha = 0
        self.addSubview(saveConfirmButton)
        
        saveConfirmButton.topAnchor.constraint(equalTo: genderStackView.bottomAnchor, constant: 150).isActive = true
        saveConfirmButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        saveConfirmButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        resetButton.setTitle("Reset", for: .normal)
        resetButton.addTarget(self, action: #selector(resetHandler), for: .touchDown)
        resetButton.titleLabel?.font = UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.text)
        resetButton.setTitleColor(FontConstants.Color.Button.Muted, for: .normal)
        resetButton.backgroundColor = UIColor.clear
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(resetButton)
        
        resetButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20).isActive = true
        resetButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! NSString

        let disclaimerAttributes = [NSAttributedStringKey.font: UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.disclaimer), NSAttributedStringKey.foregroundColor: FontConstants.Color.TextMuted]
        let versionAttributedStr = NSMutableAttributedString(string:"version \(appVersion)\n", attributes: disclaimerAttributes as [NSAttributedStringKey : Any])
        versionAttributedStr.append(NSMutableAttributedString(string: "Calculated BAC is to be used as a guide\nand not an exact unit of measure.", attributes: disclaimerAttributes as [NSAttributedStringKey : Any]))

        let disclaimerClause = UILabel()
        disclaimerClause.translatesAutoresizingMaskIntoConstraints = false
        disclaimerClause.numberOfLines = 0
        disclaimerClause.textAlignment = .center
        disclaimerClause.attributedText = versionAttributedStr //also contains the disclaimer text
        self.addSubview(disclaimerClause)
        
        disclaimerClause.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -60).isActive = true
        disclaimerClause.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        let moreInfoButton = UIButton()
        moreInfoButton.setTitle("About", for: .normal)
        moreInfoButton.addTarget(self, action: #selector(moreInfoHandler), for: .touchDown)
        moreInfoButton.setTitleColor(FontConstants.Color.GlobalWhite, for: .normal)
        moreInfoButton.backgroundColor = UIColor.clear
        moreInfoButton.translatesAutoresizingMaskIntoConstraints = false
        moreInfoButton.titleLabel?.font = UIFont(name: FontConstants.StandardBold, size: FontSingleton.sharedInstance.disclaimer)
        self.addSubview(moreInfoButton)
        
        
        moreInfoButton.topAnchor.constraint(equalTo: disclaimerClause.bottomAnchor, constant: 10).isActive = true
        moreInfoButton.centerXAnchor.constraint(equalTo: disclaimerClause.centerXAnchor).isActive = true

        locationLabel.textColor = FontConstants.Color.GlobalWhite
        locationLabel.backgroundColor = UIColor.clear
        locationLabel.font = UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.disclaimer)
        locationLabel.textAlignment = .center
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(locationLabel)
        
        setLocation.setTitle("Manually Reset Location", for: .normal)
        setLocation.addTarget(self, action: #selector(setLocationHandler), for: .touchDown)
        setLocation.setTitleColor(FontConstants.Color.GlobalWhite, for: .normal)
        setLocation.backgroundColor = UIColor.clear
        setLocation.translatesAutoresizingMaskIntoConstraints = false
        setLocation.titleLabel?.font = UIFont(name: FontConstants.StandardBold, size: FontSingleton.sharedInstance.disclaimer)
        self.addSubview(setLocation)
        
        self.loadDataIntoFields()
    }
    
    @objc func setLocationHandler() {
        let geoLocator = GeoLocatorHandler.shared
        geoLocator.forceLocationRetrieval()
    }
    
    func handleModalView() {
        modalToggle = !modalToggle
        if (modalToggle) {
            self.mainViewController?.collView.isScrollEnabled = false

            blurView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
            self.addSubview(blurView)
            
            modalInfoView.alpha = 0
            modalInfoView.parentView = self
            self.addSubview(modalInfoView)
            
            modalInfoView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
            modalInfoView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.9).isActive = true
            modalInfoView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            modalInfoView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            
            
            UIView.animate(withDuration: 0.3, animations: {
                self.blurView.effect = UIBlurEffect(style: .dark)
                self.modalInfoView.alpha = 1
                self.mainViewController?.menuBar.alpha  = 0 //force menubar to disappear

            }) { (_) in
                //
            }
        }
        else {
            mainViewController?.collView.isScrollEnabled = true
            
            UIView.animate(withDuration: 0.3, animations: {
                self.blurView.effect = nil
                self.modalInfoView.alpha = 0
                self.mainViewController?.menuBar.alpha  = 1

            }) { (_) in
                self.blurView.removeFromSuperview()
            }
        }
    }
    
    @objc func moreInfoHandler(_ button: UIButton) {
        handleModalView()
    }
    
    func loadDataIntoFields() {
        guard let settingsEntity = CoreDataHandler.fetchSettingsEntity() else {
            assert(true, "Please enter Data first, no data updated into fields (weight and gender)")
            return
        }
        
        if let g = settingsEntity.gender {
            self.gender = g
            switch g {
            case "male":
                maleButton.isSelected = true
                break
            case "female":
                femaleButton.isSelected = true
                break
            default:
                break
            }
        }
        
        if (settingsEntity.weight > 0) {
            weightField.text = String(format:"%.2f", settingsEntity.weight)
        }
        else {
            weightField.text = "0.0"
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        locationLabel.topAnchor.constraint(equalTo: self.genderStackView.bottomAnchor, constant: 10).isActive = true
        locationLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        locationLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        setLocation.topAnchor.constraint(equalTo: self.locationLabel.bottomAnchor, constant: 5).isActive = true
        setLocation.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        setLocation.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        setLocation.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc func saveControl(_ sender: AnyObject) {
        guard let weight = Double(self.weightField.text!) else {
            weightField.becomeFirstResponder()
            return
        }
        
        guard let g = self.gender else {
            self.maleButton.flashButton()
            return
        }
        

        //saves to core data
        CoreDataHandler.saveSettingsEntity(entity: "Settings", weight: weight, gender: g)
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.saveConfirmButton.alpha = 1
        }, completion: { (_) in
            UIView.animate(withDuration: 0.2, delay: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.saveConfirmButton.alpha = 0
            }, completion: { (_) in
                
            })
        })
        
    }
    
    @objc func resetHandler(_ sender: AnyObject) {
        CoreDataHandler.deleteAllObjectsInEntity(entityName: "DrinkStats")
        CoreDataHandler.deleteAllObjectsInEntity(entityName: "Settings")
        weightField.text = ""
        gender = nil
        maleButton.isSelected = false
        femaleButton.isSelected = false
        mainViewController?.totalStandardDrinks = 0.0
        mainViewController?.timerStateHandler(state: ClockState.Stop)

    }
    
    @objc func genderControl(_ sender: AnyObject) {
        switch sender.tag {
        case GenderButtonTag.Male.hashValue:
            maleButton.isSelected = !maleButton.isSelected
            femaleButton.isSelected = false
            gender = "male"
            break
        case GenderButtonTag.Female.hashValue:
            femaleButton.isSelected = !femaleButton.isSelected
            maleButton.isSelected = false
            gender = "female"
            break
        default:
            break
        }
    }
}
