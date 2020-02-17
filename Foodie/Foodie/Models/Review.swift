//
//  Review.swift
//  Foodie
//
//  Created by Nathan Hedgeman on 2/6/20.
//  Copyright © 2020 Nathan Hedgeman. All rights reserved.
//

import Foundation

struct Review1: Codable {
    
    var id: Int?
    var userId: Int?
    var name: String?
    var restaurantId: Int?
    var reviewDisc: String?
    var priceRating: Int?
    var serviceRating: Int?
    var foodRating: Int?
}
