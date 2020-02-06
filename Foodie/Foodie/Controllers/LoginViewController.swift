//
//  LoginViewController.swift
//  Foodie
//
//  Created by Nathan Hedgeman on 2/6/20.
//  Copyright © 2020 Nathan Hedgeman. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let networkController = NetworkController()
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUPButton(_ sender: Any) {
        guard let username = usernameTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let email = emailTextField.text else {return}
        guard let city = cityTextField.text else {return}
        
        let newUser = Foodie1(username: username, password: password, email: email, city: city)
        
        networkController.signUp(with: newUser) { (error) in
            if let error = error {
                NSLog("Error signing up \(error)")
            }
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
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
