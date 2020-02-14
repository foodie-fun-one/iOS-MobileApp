//
//  ReviewRestaurantViewController.swift
//  Foodie
//
//  Created by Nathan Hedgeman on 2/6/20.
//  Copyright © 2020 Nathan Hedgeman. All rights reserved.
//

import Foundation
import UIKit

class ReviewRestaurantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
       
    
    //Properties
    let networkController = NetworkController()
    let restaurantController = RestaurantController()
    var currentRestaurant: Restaurant1?
    
    @IBOutlet weak var reviewsTabelView: UITableView!
    @IBOutlet weak var priceRatingSC: UISegmentedControl!
    @IBOutlet weak var foodRatingSC: UISegmentedControl!
    @IBOutlet weak var serviceRatingSC: UISegmentedControl!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewsTabelView.delegate = self
        nameLabel.text = currentRestaurant?.name
        cityLabel.text = currentRestaurant?.address
        hoursLabel.text = currentRestaurant?.hours
        
        // Do any additional setup after loading the view.
        networkController.fetchCurrentRestaurantReviews(currentRestaurant: currentRestaurant!) { (error) in
            if let error = error {
                NSLog("Could not get Details: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.reviewsTabelView.reloadData()
                }
            }
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        guard let reviewDisc = reviewTextView.text,
            let currentRestaurantID = currentRestaurant?.id else {return}
            
        let priceRating = priceRatingSC.selectedSegmentIndex
        let serviceRating = serviceRatingSC.selectedSegmentIndex
        let foodRating = foodRatingSC.selectedSegmentIndex
        

        let newReview = Review1(id: nil, userId: 3, restaurantId: currentRestaurantID, reviewDisc: reviewDisc, priceRating: priceRating, serviceRating: serviceRating, foodRating: foodRating)

        networkController.updateRestaurantReview(review: newReview) { (error) in
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
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? DetailedReviewViewController else {return}
        
        destination.currentRestaurant = currentRestaurant
        if let indexPath = reviewsTabelView.indexPathForSelectedRow {
            destination.review = currentRestaurant?.reviews?[indexPath.row]
        }
        
    }
    

}

extension ReviewRestaurantViewController {
     
    //NEED TO FIX TABLE VIEW TO WORK Probably need a table view controller
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (currentRestaurant?.reviews!.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let count = currentRestaurant?.reviews?[indexPath.row + 1]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath)
        
        cell.textLabel?.text = currentRestaurant?.name
        cell.detailTextLabel?.text = String("\(count)")
        
        return cell
    }
}
