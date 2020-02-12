//
//  ReviewRestaurantViewController.swift
//  Foodie
//
//  Created by Nathan Hedgeman on 2/6/20.
//  Copyright © 2020 Nathan Hedgeman. All rights reserved.
//

import UIKit

class ReviewRestaurantViewController: UIViewController {
    
    //Properties
    var networkController = NetworkController()
    var currentRestaurant: Restaurant1?
    @IBOutlet weak var priceRatingSC: UISegmentedControl!
    @IBOutlet weak var foodRatingSC: UISegmentedControl!
    @IBOutlet weak var serviceRatingSC: UISegmentedControl!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = currentRestaurant?.name
        cityLabel.text = currentRestaurant?.address
        hoursLabel.text = currentRestaurant?.hours
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        guard let currentRestaurant = currentRestaurant else {return}
        currentRestaurant.priceRating = priceRatingSC.selectedSegmentIndex + 1
        currentRestaurant.foodRating = foodRatingSC.selectedSegmentIndex + 1
        currentRestaurant.serviceRating = serviceRatingSC.selectedSegmentIndex + 1
        
        guard let reviewText = reviewTextView.text else {return}
        currentRestaurant.reviewsDisc = reviewText
     
        networkController.updateRestaurant(restaurant: currentRestaurant) { (error) in
            if let error = error {
                NSLog("Error creating Restaurant \(error)")
            } else {
                DispatchQueue.main.async {
                    self.priceRatingSC.selectedSegmentIndex = 0
                    self.foodRatingSC.selectedSegmentIndex = 0
                    self.serviceRatingSC.selectedSegmentIndex = 0
                    self.reviewTextView.text = ""
                }
            }
        }
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
