//
//  Restaurant.swift
//  Foodie
//
//  Created by Nathan Hedgeman on 2/6/20.
//  Copyright © 2020 Nathan Hedgeman. All rights reserved.
//

import Foundation

class Restaurant1: Codable {
    
    var id: Int?
    let name: String
    var address: String
    var hours: String?
    var reviewsDisc: String?
    var priceRating: Int?
    var serviceRating: Int?
    var foodRating: Int?
    
    init(name: String, address: String, hours: String?) {
        self.name = name
        self.address = address
        self.hours = hours
    }
}
