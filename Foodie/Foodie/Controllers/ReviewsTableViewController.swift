//
//  ReviewsTableViewController.swift
//  Foodie
//
//  Created by Nathan Hedgeman on 2/14/20.
//  Copyright © 2020 Nathan Hedgeman. All rights reserved.
//

import UIKit

class ReviewsTableViewController: UITableViewController {
    
    let networkController = NetworkController()
    var restaurantController: RestaurantController?
    var currentRestaurant: Restaurant1?

    override func viewDidLoad() {
        super.viewDidLoad()

        networkController.fetchCurrentRestaurantReviews(currentRestaurant: currentRestaurant!) { (error) in
                if let error = error {
                    NSLog("Could not get Details: \(error)")
                } else {
                    DispatchQueue.main.async {
                        
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
        return currentRestaurant?.reviews?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath)
        
        cell.textLabel?.text = currentRestaurant?.name
        cell.detailTextLabel?.text = "Working on it"

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        guard let destination = segue.destination as? DetailedReviewViewController else {return}
        destination.currentRestaurant = currentRestaurant
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        destination.review = currentRestaurant?.reviews?[indexPath.row]
        
    }
    

}
