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
    
    
    @IBOutlet weak var seeAllReviewsButton: UIButton!
    @IBOutlet weak var priceRatingSC: UISegmentedControl!
    @IBOutlet weak var foodRatingSC: UISegmentedControl!
    @IBOutlet weak var serviceRatingSC: UISegmentedControl!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let restaurantName = currentRestaurant?.name  else {return}
        nameLabel.text = currentRestaurant?.name
        cityLabel.text = currentRestaurant?.address
        hoursLabel.text = currentRestaurant?.hours
        seeAllReviewsButton.titleLabel?.text = "See All Reviews for \(restaurantName)"
        // Do any additional setup after loading the view.
        networkController.fetchCurrentRestaurantReviews(currentRestaurant: currentRestaurant!) { (error) in
            if let error = error {
                NSLog("Could not get Details: \(error)")
            } else {
                DispatchQueue.main.async {
                    
                }
            }
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        guard let reviewDisc = reviewTextView.text,
            let currentRestaurantID = currentRestaurant?.id else {return}
            
        let priceRating = priceRatingSC.selectedSegmentIndex + 1
        let serviceRating = serviceRatingSC.selectedSegmentIndex + 1
        let foodRating = foodRatingSC.selectedSegmentIndex + 1
        

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
        guard let destination = segue.destination as? UINavigationController else {return}
        guard let targetDestination = destination.topViewController as? ReviewsTableViewController else {return}
        
        targetDestination.currentRestaurant = currentRestaurant
        
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
