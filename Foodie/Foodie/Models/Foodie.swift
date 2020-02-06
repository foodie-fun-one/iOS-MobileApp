//
//  Foodie.swift
//  Foodie
//
//  Created by Nathan Hedgeman on 2/6/20.
//  Copyright © 2020 Nathan Hedgeman. All rights reserved.
//

import Foundation

class Foodie1: Codable {
    
    var id: String?
    let username: String
    let password: String
    let email: String
    let city: String
    var reviews: [Review1]?
    
    init(username: String, password: String, email: String, city: String) {
        self.username = username
        self.password = password
        self.email = email
        self.city = city
    }
}
