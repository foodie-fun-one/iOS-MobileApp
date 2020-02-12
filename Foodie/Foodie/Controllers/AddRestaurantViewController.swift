//
//  AddRestaurantViewController.swift
//  Foodie
//
//  Created by Nathan Hedgeman on 2/6/20.
//  Copyright © 2020 Nathan Hedgeman. All rights reserved.
//

import UIKit

class AddRestaurantViewController: UIViewController {
    //let restaurantController = RestaurantController()
    let networkController = NetworkController()
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var hoursTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if networkController.bearer == nil {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "LoginSegue", sender: Any?.self)
            }
        }
    }
    
    
    @IBAction func reviewButton(_ sender: Any) {
        
        guard let name = nameTextField.text else {return}
        guard let city = cityTextField.text else {return}
        guard let hours = hoursTextField.text else {return}
        
        let new = Restaurant1(name: name, address: city, hours: hours)
        restaurantController.currentRestaurant = new
        networkController.addRestaurant(restaurant: new) { (error) in
            if let error = error {
                NSLog("Error adding Restaurant: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.nameTextField.text = ""
                    self.cityTextField.text = ""
                    self.hoursTextField.text = ""
                    self.performSegue(withIdentifier: "ToRestaurantTableViewSegue", sender: Any?.self)
                }
            }
        }
    }
}
