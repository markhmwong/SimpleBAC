//
//  DrinkButton.swift
//  LastDrop
//
//  Created by Mark Wong on 20/9/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

enum Drink: Int {
    case BeerSmall = 0
    case BeerStandard
    case BeerFull
    case WineSmall
    case WineHalf
    case WineFull
    case SpiritSmall
    case SpiritHalf
    case SpiritFull
}

class DrinkButton: BaseButton {
    
    override func setupButton() {
        
        self.addTarget(self, action: #selector(addDrink), for: .touchDown)
        
    }
    
    //drink size
    //alcohol
    //
    @objc func addDrink(_ button: DrinkButton) {
        
        
        switch button.tag {
        case Drink.BeerSmall.rawValue:
            print("Light beer!")
        case Drink.BeerSmall.rawValue:
            print("Small beer!")
        default:
            print("Light beer!")

        }
        
        
        print("\(button.tag)")
    }
}
