//
//  Review.swift
//  Foodie
//
//  Created by Nathan Hedgeman on 2/6/20.
//  Copyright © 2020 Nathan Hedgeman. All rights reserved.
//

import Foundation

class Review1: Codable {
    
    let id: String
    let menuItem: String
    let cuisineType: String
    var price: Int
    var review: String
    var rating: Int
}
