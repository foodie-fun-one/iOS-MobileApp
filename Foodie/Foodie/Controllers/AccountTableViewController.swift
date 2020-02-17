//
//  AccountTableViewController.swift
//  Foodie
//
//  Created by Nathan Hedgeman on 2/15/20.
//  Copyright © 2020 Nathan Hedgeman. All rights reserved.
//

import UIKit

class AccountTableViewController: UITableViewController {

    let networkController = NetworkController()
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        networkController.fetchUser { (error) in
                   if let error = error {
                      NSLog("Error fetching user: \(error)")
                   } else {
                       DispatchQueue.main.async {
                           self.updateViews()
                       }
                   }
               }
        
        networkController.fetchUserReviews { (error) in
            if let error = error {
                NSLog("Error getting reviews: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userController.profileUser?.reviews?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath)
        guard let review = userController.profileUser?.reviews?[indexPath.row] else {return cell}
        
        guard let rate1 = review.foodRating,
            let rate2 = review.priceRating,
            let rate3 = review.serviceRating else {return cell}
        
        let averageRating = (rate1 + rate2 + rate3)/3
        
        cell.textLabel?.text = review.name
        cell.detailTextLabel?.text = String("Overall Rating:\(averageRating)")
        
        
        return cell
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let review = userController.profileUser?.reviews?[indexPath.row] else {return}
            networkController.deleteReview(review: review) { (error) in
                if let error = error {
                    NSLog("Error deleting review: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        self.tableView.reloadData()
                    }
                }
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        guard let destination = segue.destination as? ProfileReviewDetailedViewController else {return}
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        destination.review = userController.profileUser?.reviews?[indexPath.row]
    }

}

extension AccountTableViewController {
    
    func updateViews() {
        
        guard let username = userController.profileUser?.username,
            let email = userController.profileUser?.email else {return}
        
        usernameLabel.text = username
        emailLabel.text = email
    }
    
}
