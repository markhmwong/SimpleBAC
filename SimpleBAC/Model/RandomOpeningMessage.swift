//
//  RandomOpeningMessage.swift
//  SimpleBAC
//
//  Created by Mark Wong on 27/10/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import Foundation

struct RandomOpeningMessage {
    var message: [String] = [
        "A fun night is filled with good drinks 🍾.",
        "Nothing beats a nice cold 🍺 at the end of the day.",
        "🍺, 🍷, 🥃, take your pick tonight",
        "How many bottles we stacking on the wall tonight?",
        "Drinking responsibly means to not spill it. But seriously, dirnk responsibly.",
        "Soup of the day is whiskey",
        "The whole world is three drinks behind.",
        "Liquid diet every friday night. Don't forget water."
    ]
    
    func pickRandomString() -> String{
        let range: ClosedRange = 0...message.count-1
        let randomNumber = Int.random(in: range)
        
        return message[randomNumber]
    }
}
