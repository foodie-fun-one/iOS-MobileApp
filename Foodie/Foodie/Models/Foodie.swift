//
//  Foodie.swift
//  Foodie
//
//  Created by Nathan Hedgeman on 2/6/20.
//  Copyright © 2020 Nathan Hedgeman. All rights reserved.
//

import Foundation

class Foodie1: Codable {
    
    let id: String?
    let username: String
    let password: String
    let email: String
    let city: String
    var reviews: [Review1]?
}
