//
//  Country.swift
//  SimpleBAC
//
//  Created by Mark Wong on 25/10/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import Foundation

struct CountryObj: Decodable {
    
    let legalLimit: Float
    let alcoholMass: Float
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case legalLimit = "legalLimit"
        case alcoholMass = "alcoholMass"
    }
}

struct CountryArr: Decodable {
    let country: [CountryObj]
    enum CodingKeys: String, CodingKey {
        case country = "country"
    }
}
