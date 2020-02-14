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
    @IBOutlet weak var priceRatingSC: UISegmentedControl!
    @IBOutlet weak var foodRatingSC: UISegmentedControl!
    @IBOutlet weak var serviceRatingSC: UISegmentedControl!
    @IBOutlet weak var reviewTextView: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let serviceRating = review?.serviceRating,
            let foodRating = review?.foodRating,
            let priceRating = review?.priceRating,
            let review = review?.reviewDisc,
            let name = currentRestaurant?.name else {return}
        
        self.nameLabel.text = "\(name) Review"
        self.serviceRatingSC.selectedSegmentIndex = serviceRating
        self.foodRatingSC.selectedSegmentIndex = foodRating
        self.priceRatingSC.selectedSegmentIndex = priceRating
        self.reviewTextView.text = review
        
    }
}
