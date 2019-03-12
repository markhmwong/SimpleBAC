//
//  AlcoholicDrink.swift
//  LastDrop
//
//  Created by Mark Wong on 8/8/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import Foundation
import CoreLocation

enum Country: String {
    case Australia // we have dangerous insects and animals and stuff
    case Austria
    case Canada
    case China
    case Denmark
    case Finland
    case France
    case Germany // My engineering is pretty good
    case HongKong = "Hong Kong"
    case Hungary
    case Iceland
    case Ireland
    case Italy
    case Japan
    case Netherlands
    case Poland
    case Portugal
    case Spain
    case Switzerland
    case UnitedKingdom = "United Kingdom" // Tea please
    case UnitedStates = "United States" // i thought this was 'murica!
    case Unknown
}

class AlcoholicDrink: NSObject {
    //constants
    let rate: Float = 0.015
    let finalTime: Float = 0 // means the time for the bac to reach 0
    
    // men - 0.73 women - 0.66
    var widmark: Float = 0.0
    
    //variables affected by country
    static var alcoholMass: Float = 10
    static var limit: Float = 0.05
    
    //user
    var weight: Float = 0.0
    var drinks: Float = 0.0 // a standard drink
    
    //time
    var startingTime: Date? = nil
    
    var bac: Float = 0
    var hours: Int = 0
    var timeRemainingInSeconds: Float = 0.0
    var gender: String = "" {
        didSet {
            if (self.gender == "male") {
                widmark = 0.73
            }
            else {
                widmark = 0.66
            }
        }
    }
    
    static var country: String = ""
    
    override init() {
        
    }
    
    //still in use in update
    init(weightInKgs: Float, drinksConsumed: Float, gender: String, date: NSDate) {
        super.init()
        self.weight = weightInKgs
        self.drinks = drinksConsumed //will need to save drink consumed in CoreData
        self.startingTime = date as Date        
        //didSet doesn't work in init. must be called after. defer is a work around
        defer {
            self.gender = gender
        }
    }
    
    init(weightInKgs: Float, gender: String, percentageOfDrinkConsumed: Float) {
        super.init()
        self.weight = weightInKgs
        self.drinks = percentageOfDrinkConsumed
        self.startingTime = Date()
//        AlcoholicDrink.alcoholMass = percentageOfDrinkConsumed //update based on country
        
        //didSet doesn't work in init. must be called after. defer is a work around
        defer {
            self.gender = gender
        }
    }
    
    func calculateAllStats() -> Void {
        self.calculateBAC()
        self.calculateTimeRemaining()
    }
    
    /*
        Formula to calculate the BAC
    */
    func calculateBAC() -> Void {
        self.bac = (AlcoholicDrink.alcoholMass * self.drinks) / (self.widmark * self.weight * 1000) * 100 - (self.rate * self.finalTime)
    }
    
    /*
        The amount of time in seconds remaining to reach 0
     */
    func calculateTimeRemaining() {
        self.timeRemainingInSeconds = (((AlcoholicDrink.alcoholMass * self.drinks) * 100 / (self.widmark * self.weight * 1000)) / self.rate) * 3600
    }
    
    func updateStartTime(date: Date) {
        self.startingTime = date
    }
    
    func printObject() {
        print(self.timeRemainingInSeconds)
        print(self.timeRemainingInSeconds / 3600)
        let mins = (self.timeRemainingInSeconds / 60).truncatingRemainder(dividingBy: 60)
        print(mins)
        print(self.timeRemainingInSeconds.truncatingRemainder(dividingBy: 60))
        print(self.bac)
    }
    
    static func jsonTest() {
        
        if let path = Bundle.main.path(forResource: "Country", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let model = try decoder.decode(CountryArr.self, from: data)
                
                let countryArr = model.country
                print(countryArr.count)
                _ = countryArr.sorted { (countryA, countryB) -> Bool in
                   return countryA.name < countryB.name
                }
            }
            catch let err {
                print("\(err)")
            }
        }
        else {
            print("could not open/find")
        }
    }
    
    //apply country and it's standard drink measurement
    static func applyStandardDrink(country: String) -> Void {
//        let testCountry = "United States"
        self.country = country
        switch country {
        case Country.Australia.rawValue:
            AlcoholicDrink.alcoholMass = 10
            AlcoholicDrink.limit = 0.05
            break
        case Country.Austria.rawValue:
            AlcoholicDrink.alcoholMass = 20
            AlcoholicDrink.limit = 0.05
            break
        case Country.Canada.rawValue:
            AlcoholicDrink.alcoholMass = 13.45
            AlcoholicDrink.limit = 0.05
            break
        case Country.China.rawValue:
            AlcoholicDrink.alcoholMass = 10.0
            AlcoholicDrink.limit = 0.08
            break
        case Country.Denmark.rawValue:
            AlcoholicDrink.alcoholMass = 12
            AlcoholicDrink.limit = 0.05
            break
        case Country.Finland.rawValue:
            AlcoholicDrink.alcoholMass = 12
            AlcoholicDrink.limit = 0.05
            break
        case Country.France.rawValue:
            AlcoholicDrink.alcoholMass = 10
            AlcoholicDrink.limit = 0.05
            break
        case Country.Germany.rawValue:
            AlcoholicDrink.alcoholMass = 10
            AlcoholicDrink.limit = 0.05
            break
        case Country.HongKong.rawValue:
            AlcoholicDrink.alcoholMass = 10
            AlcoholicDrink.limit = 0.05
            break
        case Country.Hungary.rawValue:
            AlcoholicDrink.alcoholMass = 17
            AlcoholicDrink.limit = 0.00
            break
        case Country.Iceland.rawValue:
            AlcoholicDrink.alcoholMass = 8
            AlcoholicDrink.limit = 0.05
            break
        case Country.Ireland.rawValue:
            AlcoholicDrink.alcoholMass = 10
            AlcoholicDrink.limit = 0.05
            break
        case Country.Italy.rawValue:
            AlcoholicDrink.alcoholMass = 10
            AlcoholicDrink.limit = 0.05
            break
        case Country.Japan.rawValue:
            AlcoholicDrink.alcoholMass = 19.75
            AlcoholicDrink.limit = 0.03
            break
        case Country.Netherlands.rawValue:
            AlcoholicDrink.alcoholMass = 10
            AlcoholicDrink.limit = 0.05
            break
        case Country.Poland.rawValue:
            AlcoholicDrink.alcoholMass = 10
            AlcoholicDrink.limit = 0.02
            break
        case Country.Portugal.rawValue:
            AlcoholicDrink.alcoholMass = 14
            AlcoholicDrink.limit = 0.05
            break
        case Country.Spain.rawValue:
            AlcoholicDrink.alcoholMass = 10
            AlcoholicDrink.limit = 0.05
            break
        case Country.Switzerland.rawValue:
            AlcoholicDrink.alcoholMass = 12
            AlcoholicDrink.limit = 0.05
            break
        case Country.UnitedKingdom.rawValue:
            AlcoholicDrink.alcoholMass = 8
            AlcoholicDrink.limit = 0.08
            break
        case Country.UnitedStates.rawValue:
            AlcoholicDrink.alcoholMass = 14
            AlcoholicDrink.limit = 0.02
            break
        case Country.Unknown.rawValue:
            AlcoholicDrink.alcoholMass = 10
            AlcoholicDrink.limit = 0.05
            break
        default:
            //WHO Standard numbers
            AlcoholicDrink.alcoholMass = 10
            AlcoholicDrink.limit = 0.05
            break
        }
    }
}
