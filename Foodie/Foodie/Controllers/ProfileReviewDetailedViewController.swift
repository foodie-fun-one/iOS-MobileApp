//
//  ProfileReviewDetailedViewController.swift
//  
//
//  Created by Nathan Hedgeman on 2/16/20.
//

import UIKit

class ProfileReviewDetailedViewController: UIViewController {
    
    let networkController = NetworkController()
    var review: Review1?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceRatingLabel: UILabel!
    @IBOutlet weak var foodRatingLabel: UILabel!
    @IBOutlet weak var serviceRatingLabel: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        updateViews()
        
        
        // Do any additional setup after loading the view.
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

extension ProfileReviewDetailedViewController {
    func updateViews() {
        guard let name = review?.name,
            let priceRating = review?.priceRating,
            let foodRating = review?.foodRating,
            let serviceRating = review?.serviceRating,
            let reviewText = review?.reviewDisc else {return}
        
        nameLabel.text = name
        priceRatingLabel.text = "\(priceRating)"
        foodRatingLabel.text = "\(foodRating)"
        serviceRatingLabel.text = "\(serviceRating)"
        reviewTextView.text = reviewText
        
    }
}
