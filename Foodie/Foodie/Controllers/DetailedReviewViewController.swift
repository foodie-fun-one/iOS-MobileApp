//
//  DetailedReviewViewController.swift
//  Foodie
//
//  Created by Nathan Hedgeman on 2/14/20.
//  Copyright © 2020 Nathan Hedgeman. All rights reserved.
//

import UIKit

class DetailedReviewViewController: UIViewController {
    
    var currentRestaurant: Restaurant1?
    var review: Review1?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceRatingLabel: UILabel!
    @IBOutlet weak var foodRatingLabel: UILabel!
    @IBOutlet weak var serviceRatingLabel: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let serviceRating = review?.serviceRating,
            let foodRating = review?.foodRating,
            let priceRating = review?.priceRating,
            let review = review?.reviewDisc,
            let name = currentRestaurant?.name else {return}
        
        self.nameLabel.text = "\(name) Review"
        self.serviceRatingLabel.text = String(serviceRating)
        self.foodRatingLabel.text = String(foodRating)
        self.priceRatingLabel.text = String(priceRating)
        self.reviewTextView.text = review
        
    }
}
