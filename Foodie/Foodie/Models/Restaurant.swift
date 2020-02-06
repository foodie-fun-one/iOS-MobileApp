//
//  Restaurant.swift
//  Foodie
//
//  Created by Nathan Hedgeman on 2/6/20.
//  Copyright © 2020 Nathan Hedgeman. All rights reserved.
//

import Foundation

struct Restaurant1: Codable {
    
    let id: Int?
    let name: String
    var address: String
    var hours: String
    var reviews: [Review1]?
}
