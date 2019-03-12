//
//  ViewController.swift
//  LastDrop
//
//  Created by Mark Wong on 19/8/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit
import UserNotifications

enum ViewCellId: String {
    case HomeScreenCellId = "stats"
    case DrinksScreenCellId = "drinks"
    case WorldScreenCellId = "world"
}

enum ClockState {
    case Start
    case Stop
    case Running
}

class LastDropRootViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, GeoLocatorProtocol {
    let menuBar = MenuBar()
    var keyboardDismissGesture: UITapGestureRecognizer?
    var lastContentOffsetX: CGFloat?
    var clockState: ClockState?
    var bacTimer: Timer?
    var detailsScreenViewCell: DetailsScreenView?
    var drinkScreenViewCell: DrinksScreenView?
    var menuBarBottom: CGFloat = 0.0
    var bacRemainingForLabel: Float = 0
    var timeRemainingForLabel: String = ""
    let whatsNewView = WhatsNewView()
    let whatsNewBlurView = UIVisualEffectView()
    let defaults = UserDefaults.standard
    var summaryText: String = ""
    let summaryHighlightAttribute = [NSAttributedStringKey.font: UIFont(name: FontConstants.StandardBold, size: FontSingleton.sharedInstance.mainResult * 0.6), NSAttributedStringKey.foregroundColor: UIColor.orange]

    lazy var collView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        bacTimer?.invalidate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        bacTimer?.invalidate()
    }
    
    func prepareFont() -> Void {
        
        let fontInstance = FontSingleton.sharedInstance
        fontInstance.configureFontSize()
        
    }
    
    func splashScreen() {
        let splashView = UIView()
        splashView.backgroundColor = Indian.CellViewBackground
        splashView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(splashView)
        
        splashView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        splashView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        splashView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        splashView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        let titleA: UILabel = UILabel()
        titleA.frame = CGRect(x: 0, y: 0, width: 120, height: 50)
        titleA.text = "Simple"
        titleA.font = UIFont(name: FontConstants.StandardBold, size: 40)
        titleA.backgroundColor = UIColor.white
        titleA.translatesAutoresizingMaskIntoConstraints = false
        splashView.addSubview(titleA)
        
        titleA.bottomAnchor.constraint(equalTo: splashView.centerYAnchor).isActive = true
        titleA.centerXAnchor.constraint(equalTo: splashView.centerXAnchor).isActive = true
        
        let title: UILabel = UILabel()
        title.frame = CGRect(x: 0, y: 0, width: 120, height: 80)
        title.text = "BAC"
        title.font = UIFont(name: FontConstants.StandardBold, size: 61)
        title.backgroundColor = UIColor.white
        title.translatesAutoresizingMaskIntoConstraints = false
        splashView.addSubview(title)
        
        title.topAnchor.constraint(equalTo: splashView.centerYAnchor).isActive = true
        title.centerXAnchor.constraint(equalTo: splashView.centerXAnchor).isActive = true
        
        
        UIView.animate(withDuration: 0.5, delay: 0.8, options: [.curveEaseInOut], animations: {
            splashView.alpha = 0
        }) { (_) in
            //
        }
    }
    
    func authoriseNotifications() {
//        // create the alert
//        let alert = UIAlertController(title: "Notice", message: "Lauching this missile will destroy the entire universe. Is this what you intended to do?", preferredStyle: UIAlertController.Style.alert)
//
//        // add the actions (buttons)
//        alert.addAction(UIAlertAction(title: "Remind Me Tomorrow", style: UIAlertAction.Style.default, handler: nil))
//        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
//        alert.addAction(UIAlertAction(title: "Launch the Missile", style: UIAlertAction.Style.destructive, handler: nil))
//
//        // show the alert
//        self.present(alert, animated: true, completion: nil)
        



    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareFont()
        self.discoverCountry()
        self.prepareCollectionView()
        self.prepareMenuBar()
        self.splashScreen()
        self.authoriseNotifications()
        //check clockstate
        if (self.clockState == nil) {
            self.clockState = ClockState.Stop
        }
        
        totalStandardDrinks = defaults.float(forKey: "TotalStandardDrinks")
        if let string = defaults.string(forKey: "StartingTimeString") {
            startingTimeStr = string
        }
        
        //keyboard functions
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        self.showWhatsNew()
//        self.showWhatsNewAlwaysOn()
    }

    //set collection view offset so it begins at the middle cell - drinks cell view
    override func viewDidAppear(_ animated: Bool) {
        let deviceHeight = Device.TheCurrentDeviceHeight
        print(deviceHeight)
        self.setInitialIndex(index: 1)
    }
    
    func showWhatsNewAlwaysOn() {
        whatsNewBlurView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        whatsNewBlurView.effect = UIBlurEffect(style: .dark)
        whatsNewView.mainViewController = self
        self.view.addSubview(whatsNewBlurView)
        whatsNewView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(whatsNewView)
        
        whatsNewView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        whatsNewView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        whatsNewView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        whatsNewView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6).isActive = true
        
    }
    
    func showWhatsNew() {
        let defaults = UserDefaults.standard
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? NSString
        guard let av = appVersion else {
            return
        }
        
        if (defaults.float(forKey: "AppVersion") == 0.0) {
            whatsNewBlurView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            whatsNewBlurView.effect = UIBlurEffect(style: .dark)
            whatsNewView.mainViewController = self
            self.view.addSubview(whatsNewBlurView)
            whatsNewView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(whatsNewView)
            
            whatsNewView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
            whatsNewView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
            whatsNewView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
            whatsNewView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6).isActive = true
            
            defaults.set(av, forKey: "AppVersion")
        }
        else if (defaults.float(forKey: "AppVersion") < av.floatValue) {
            //show summary of new features
            whatsNewBlurView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            whatsNewBlurView.effect = UIBlurEffect(style: .dark)
            whatsNewView.mainViewController = self
            self.view.addSubview(whatsNewBlurView)
            whatsNewView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(whatsNewView)
            
            whatsNewView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
            whatsNewView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
            whatsNewView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
            whatsNewView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6).isActive = true
            
            defaults.set(av, forKey: "AppVersion")
        }
    }
    
    func removeWhatsNewView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.whatsNewBlurView.effect = nil
            self.whatsNewView.alpha = 0
        }) { (_) in
            self.whatsNewView.removeFromSuperview()
            self.whatsNewBlurView.removeFromSuperview()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuBar.menuBarNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellId: String
        var cell: UICollectionViewCell
        if (indexPath.item == 2) {
            cellId = ViewCellId.WorldScreenCellId.rawValue
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        }
        else if (indexPath.item == 1) {
            cellId = ViewCellId.DrinksScreenCellId.rawValue
            drinkScreenViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? DrinksScreenView
            drinkScreenViewCell?.mainViewController = self
            return drinkScreenViewCell!
        }
        else {
            cellId = ViewCellId.HomeScreenCellId.rawValue
            detailsScreenViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? DetailsScreenView
            detailsScreenViewCell?.mainViewController = self
            return detailsScreenViewCell!
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }
    
    func setInitialIndex(index: Int) {
        let indexPath = NSIndexPath(item: index, section: 0)
        collView.scrollToItem(at: indexPath as IndexPath, at: .centeredHorizontally, animated: false)
    }
    
    func scrollToSettings() {
        let indexPath = NSIndexPath(item: 0, section: 0)
        collView.scrollToItem(at: indexPath as IndexPath, at: .centeredHorizontally, animated: true)
    }
    
    func prepareMenuBar() {
        view.addSubview(menuBar)
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: Theme.View.MenuBar.Size.Height).isActive = true
        self.menuBarBottom = self.menuBar.frame.origin.y + self.menuBar.frame.height

    }
    
    func prepareCollectionView() {
        self.view.addSubview(collView)
        
        collView.showsHorizontalScrollIndicator = false
        collView.backgroundColor = Indian.CellViewBackground
        collView.isPagingEnabled = true
        collView.translatesAutoresizingMaskIntoConstraints = false
        collView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        collView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        collView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1).isActive = true
        
        //register cells
        collView.register(DetailsScreenView.self, forCellWithReuseIdentifier: ViewCellId.HomeScreenCellId.rawValue)
//        collView.register(WorldScreenView.self, forCellWithReuseIdentifier: ViewCellId.WorldScreenCellId.rawValue)
        collView.register(DrinksScreenView.self, forCellWithReuseIdentifier: ViewCellId.DrinksScreenCellId.rawValue)

    }
    
    @objc func keyboardDidShow(notification: Notification) {
        collView.isScrollEnabled = false
        keyboardDismissGesture = self.hideKeyboardWhenTappedAround()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        collView.isScrollEnabled = true
        if let k = keyboardDismissGesture {
            view.removeGestureRecognizer(k)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Top Menu Bar Animation
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

//        let worldCell: MenuCell = menuBar.collectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as! MenuCell
        let statCell: MenuCell = menuBar.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as! MenuCell
        let drinkCell: MenuCell = menuBar.collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as! MenuCell

        let xContentOffset = scrollView.contentOffset.x
        let scrollWidth = scrollView.bounds.width
        let origin = (xContentOffset - scrollWidth) / 2
        
        let totalMovementWidth = scrollWidth / 2
        let percentageMoved = origin / (totalMovementWidth)
        
        let labelPos = drinkCell.placeHolderLabel.frame.origin.x
        let centerOfCell = drinkCell.frame.width / 2
        let difference = labelPos - centerOfCell
        let pos = (difference * percentageMoved)
        
//        let worldLabelWidth = worldCell.placeHolderLabel.frame.size.width
//        let rightPos = (worldLabelWidth / 2) * percentageMoved
        
        let statLabelWidth = statCell.placeHolderLabel.frame.size.width
        let leftPos = (statLabelWidth / 2) * percentageMoved
        
        statCell.frame.origin.x = -origin + leftPos
        drinkCell.frame.origin.x = -origin + drinkCell.frame.width - pos
//        worldCell.frame.origin.x = -origin + ((worldCell.frame.width) * 2) + rightPos

        //white bar scroll
        //        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / CGFloat(menuBar.menuBarNames.count)
    }    
    
    func discoverCountry() {
        let geoLocator = GeoLocatorHandler.shared
        geoLocator.mainViewControllerDelegate = self

    }
    
    func updateCountry(country: String) {
       
        AlcoholicDrink.applyStandardDrink(country: country)
        if (country == "Unknown") {
            detailsScreenViewCell?.locationLabel.text = "Somewhere On Earth\n Limit: \(AlcoholicDrink.limit) Alcohol Mass: \(AlcoholicDrink.alcoholMass)"
        }
        else {
            detailsScreenViewCell?.locationLabel.text = "\(country)\n Limit: \(AlcoholicDrink.limit) Alcohol Mass: \(AlcoholicDrink.alcoholMass)"
        }
        

    }
    
    //scheduler
    func timerStateHandler(state: ClockState) -> Void {
        switch state {
        case .Start:
            clockState = ClockState.Running
            self.bacTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
            break
        case .Stop:
            clockState = ClockState.Stop
            bacTimer?.invalidate()
            
            let timeAttributes:[NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.disclaimer)!, NSAttributedStringKey.foregroundColor: FontConstants.Color.GlobalWhite]
            let resultAttributes:[NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.mainResult)!, NSAttributedStringKey.foregroundColor: FontConstants.Color.Global]
            let attributedStr  = NSMutableAttributedString(string: "00", attributes: resultAttributes)
            let hourTitleAttString = NSMutableAttributedString(string: "HR", attributes: timeAttributes)
            attributedStr.append(hourTitleAttString)
            
            let minAttString = NSMutableAttributedString(string: "00", attributes: resultAttributes)
            attributedStr.append(minAttString)
            let minTitleAttString = NSMutableAttributedString(string: "MIN", attributes: timeAttributes)
            attributedStr.append(minTitleAttString)
            
            let secAttString = NSMutableAttributedString(string: "00", attributes: resultAttributes)
            attributedStr.append(secAttString)
            let secTitleAttString = NSMutableAttributedString(string: "SEC", attributes: timeAttributes)
            attributedStr.append(secTitleAttString)
            let totalBacAttributedString = NSMutableAttributedString(string: String(format:"%.4f", 0.0000), attributes: [NSAttributedStringKey.font: UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.mainResult)!, NSAttributedStringKey.foregroundColor: FontConstants.Color.Global])
            self.drinkScreenViewCell?.updateResult(results: [NSMutableAttributedString(string: String(format:"%.4f", 0.000), attributes: [NSAttributedStringKey.font: UIFont(name: FontConstants.Standard, size: FontSingleton.sharedInstance.mainResult)!, NSAttributedStringKey.foregroundColor: FontConstants.Color.Global]), attributedStr, totalBacAttributedString])
            break
        case .Running:
            //do nothing
            break
        }
    }
    
    var totalStandardDrinks: Float = 0.0
    var startingTimeStr: String = ""
    func addToTotalStandardDrinks(_ stdDrink: Float) {
        totalStandardDrinks += stdDrink
    }
    
    func currentTime() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        var hourStr = ""
        var minuteStr = ""
        if (hour < 10) {
            hourStr = "0\(hour)"
        }
        else {
            hourStr = "\(hour)"
        }
        
        if (minutes < 10) {
            minuteStr = "0\(minutes)"
        }
        else {
            minuteStr = "\(minutes)"
        }
        startingTimeStr = "\(hourStr):\(minuteStr)"
    }
    
    /*
        Update the labels and recalculate every cycle (1 second) to achieve a real-time effect
     */
    
    @objc func update() -> Void {
        
        var totalTime: Float = 0
        var hours: Int = 0
        var minutes: Int = 0
        var seconds: Int = 0
        var elapsedTimeInSeconds: Float = 0 //time since last drink
        var totalBacRemaining: Float = 0
        var totalBac: Float = 0
        
        if let drinkObjArr = CoreDataHandler.fetchDrinkEntity() {
            guard let settings = CoreDataHandler.fetchSettingsEntity() else {
                return
            }
            guard let gender = settings.gender else {
                return
            }
            
            for dObj in drinkObjArr {
                guard let startTime = dObj.startTime else {
                    return
                }
                
                let a = AlcoholicDrink(weightInKgs: settings.weight, drinksConsumed: dObj.drinks, gender: gender, date: startTime)
                a.calculateAllStats()
                totalBac += a.bac
                totalTime += a.timeRemainingInSeconds
            }
            
            let drinkObj = drinkObjArr[0]
            guard let startTime = drinkObj.startTime else {
                return
            }
            let a = AlcoholicDrink(weightInKgs: settings.weight, drinksConsumed: drinkObj.drinks, gender: gender, date: startTime)
            a.calculateBAC()
//            elapsedTimeInSeconds = Float((a.startingTime?.timeIntervalSince(Date()))!)
            elapsedTimeInSeconds = -Float(Date().timeIntervalSince((a.startingTime)!))
            let bacRemaining = ((AlcoholicDrink.alcoholMass * Float(a.drinks)) / (a.widmark * a.weight * 1000)) * 100 - (a.rate * (elapsedTimeInSeconds / 3600) * -1)

            totalBacRemaining = totalBac - (a.bac - bacRemaining)
            if (bacRemaining <= 0.0) {
                
                CoreDataHandler.getContext().delete(drinkObj)
                elapsedTimeInSeconds = 0.0
                do {
                    try CoreDataHandler.getContext().save()
                }
                catch let error as NSError {
                    print("Could not fetch \(error)")
                }
            }
        }
        
        totalTime = totalTime + elapsedTimeInSeconds
        
        (hours,minutes,seconds) = secondsToHoursMinutesSeconds(totalTime: totalTime)
        
        var timeStr = ""
        if (hours > 0) {
            timeStr = hours == 1 ? "\(hours) hour" : "\(hours) hours"
        }
        else {
            if (minutes > 0) {
                timeStr = minutes == 1 ? "\(minutes) minute" : "\(minutes) minutes"
            }
            else {
                if (seconds > 0) {
                    timeStr = seconds == 1 ? "\(seconds) second" : "\(seconds) seconds"
                }
            }
        }
        print(timeStr)
        //refactor above with this
        //https://stackoverflow.com/questions/26794703/swift-integer-conversion-to-hours-minutes-seconds
        
        defaults.set(totalStandardDrinks, forKey: "TotalStandardDrinks")
        defaults.set(startingTimeStr, forKey: "StartingTimeString")
        
        let stockAttributes = [NSAttributedStringKey.font: UIFont(name: FontConstants.StandardBold, size: FontSingleton.sharedInstance.mainResult * 0.6), NSAttributedStringKey.foregroundColor: FontConstants.Color.Global]
        
        let summaryHighlightAttribute = [NSAttributedStringKey.font: UIFont(name: FontConstants.StandardBold, size: FontSingleton.sharedInstance.mainResult * 0.6), NSAttributedStringKey.foregroundColor: UIColor.orange]

        drinkScreenViewCell?.summaryText = NSMutableAttributedString(string: "You've had ", attributes: stockAttributes as [NSAttributedStringKey : Any])
        let standardDrinkAndTimeAttributedStr = NSMutableAttributedString(string: "\(totalStandardDrinks) 🍺 since \(startingTimeStr). ", attributes: summaryHighlightAttribute as [NSAttributedStringKey : Any])
        drinkScreenViewCell?.summaryText?.append(standardDrinkAndTimeAttributedStr)
        let stockTextB = NSMutableAttributedString(string: "Roughly making your BAC ", attributes: stockAttributes as [NSAttributedStringKey : Any])
        drinkScreenViewCell?.summaryText?.append(stockTextB)
        let bacAttributedStr = NSMutableAttributedString(string: "\(String(format:"%.4f", totalBacRemaining)). ", attributes: summaryHighlightAttribute as [NSAttributedStringKey : Any])
        drinkScreenViewCell?.summaryText?.append(bacAttributedStr)
        let stockTextC = NSMutableAttributedString(string: "It'll take about ", attributes: stockAttributes as [NSAttributedStringKey : Any])
        drinkScreenViewCell?.summaryText?.append(stockTextC)
        drinkScreenViewCell?.timeRemainingText = NSMutableAttributedString(string: "\(timeStr) to reach 0.", attributes: summaryHighlightAttribute as [NSAttributedStringKey : Any])
        drinkScreenViewCell?.summaryText?.append(drinkScreenViewCell?.timeRemainingText ?? NSMutableAttributedString(string: "unknown time to reach 0.", attributes: summaryHighlightAttribute as [NSAttributedStringKey : Any]))
        drinkScreenViewCell?.summaryTextView.attributedText = drinkScreenViewCell?.summaryText
        
        if (hours <= 0 && minutes <= 0 && seconds <= 0 || totalBac <= 0 || totalBacRemaining <= 0) {
            if (CoreDataHandler.deleteAllObjectsInEntity(entityName: "DrinkStats")) {
                self.timerStateHandler(state: ClockState.Stop)

            }
        }
        
        //Notifications
//        let current = UNUserNotificationCenter.current()
//        current.getPendingNotificationRequests { (requests) in
//            for request in requests {
//                if (request.identifier == "zeroBacReminder") {
////                    current.removePendingNotificationRequests(withIdentifiers: ["zeroBacReminder"])
//                    if var trigger = request.trigger {
//                        trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(totalTime), repeats: false)
//                    }
//                }
//                else {
//                    let content = UNMutableNotificationContent()
//                    content.subtitle = "Time To Zero"
//                    content.body = "<Time>"
//                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(totalTime), repeats: false)
//                    let request = UNNotificationRequest(identifier: "zeroBacReminder", content: content, trigger: trigger)
//                    current.add(request, withCompletionHandler: nil)
//                }
//            }
//        }
    }
    
    func secondsToHoursMinutesSeconds(totalTime: Float) -> (Int, Int, Int) {
        return (Int(totalTime / 3600), Int((totalTime / 60).truncatingRemainder(dividingBy: 60)), Int(totalTime.truncatingRemainder(dividingBy: 60)))
    }
    
    func checkIfZeroBAC() -> Bool {
        var totalTimeRemaining: Float = 0
        var elapsedTimeInSeconds: Float = 0 //time since last drink
        var totalBacRemaining: Float = 0
        var totalBac: Float = 0
        
        if let drinkObjArr = CoreDataHandler.fetchDrinkEntity() {
            // no data, no BAC
            guard let settings = CoreDataHandler.fetchSettingsEntity() else {
                return true
            }
            for dObj in drinkObjArr {
                
                guard let gender = settings.gender else {
                    return true
                }
                
                guard let startTime = dObj.startTime else {
                    return true
                }
                
                let a = AlcoholicDrink(weightInKgs: settings.weight, drinksConsumed: dObj.drinks, gender: gender, date: startTime)
                a.calculateAllStats()
                totalBac += a.bac
                totalTimeRemaining += a.timeRemainingInSeconds
                
                //elasped time
                elapsedTimeInSeconds = Float((a.startingTime?.timeIntervalSince(Date()))!)
                
                let bacRemaining = ((AlcoholicDrink.alcoholMass * Float(a.drinks)) / (a.widmark * a.weight * 1000)) * 100 - (a.rate * (elapsedTimeInSeconds / 3600) * -1)
                
                if (bacRemaining <= 0.001) {
                    CoreDataHandler.getContext().delete(dObj)
                    elapsedTimeInSeconds = 0.0
                    do {
                        
                        try CoreDataHandler.getContext().save()
                    }
                    catch let error as NSError {
                        print("Could not fetch \(error)")
                    }
                }
                
                totalBacRemaining += bacRemaining
            }
        }
        
        if (totalBacRemaining < 0.001 || totalTimeRemaining <= 0) {
            return true
        }
        else {
            return false
        }
    }
    
    func checkClockState() {
        if (clockState != ClockState.Running) {
            self.timerStateHandler(state: ClockState.Start)
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() -> UITapGestureRecognizer {
        let keyboardDismissGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        keyboardDismissGesture.cancelsTouchesInView = false //needs this to stop it from not accepting furhter touches after keyboard is dismissed
        view.addGestureRecognizer(keyboardDismissGesture)
        return keyboardDismissGesture
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func AskConfirmation (title:String, message:String, completion:@escaping (_ result:Bool) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            completion(true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            completion(false)
        }))
    }
}
