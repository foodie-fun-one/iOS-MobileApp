//
//  NetworkController.swift
//  Foodie
//
//  Created by Nathan Hedgeman on 2/6/20.
//  Copyright © 2020 Nathan Hedgeman. All rights reserved.
//

import Foundation
import Firebase

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
}

class NetworkController {
    
    //Properties
    let fireBase = Firestore.firestore()
    private let baseURL = URL(string: "https://foodiefun-buildweek.herokuapp.com")!
    
    var bearer = userController.currentUser?.token
    //var bearer =  Bearer(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6Ik5hdGU0IiwicGFzc3dvcmQiOiIkMmEkMTIkaGMxa29Ma0ZoYTZjN2xhYVNUazFMT2RmRUl5LjdHZk9ndjlNckVvckdZdml0ZnpoR0NQWFMiLCJpYXQiOjE1ODE4MjIzNjQsImV4cCI6MTU4MTg1MTE2NH0.HdtJVyCo3O4yKi5535-HRrxcXhPzFiC9dZyd8voCc5c")
    
    
    //Network Calls
    
    func signUp(with user: Foodie1, completion: @escaping (Error?) -> ()) {
        let signUpUrl = baseURL.appendingPathComponent("api/register")
        
        var request = URLRequest(url: signUpUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            //print(request.httpBody!)
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 201 {
                completion(NSError(domain: "", code: response.statusCode, userInfo:nil))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
            }.resume()
    }
    
    func signIn(with user: Foodie1, completion: @escaping (Error?) -> ()) {
        let loginUrl = baseURL.appendingPathComponent("api/login")
        
        var request = URLRequest(url: loginUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo:nil))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            let decoder = JSONDecoder()
            do {
                userController.currentUser = try decoder.decode(CurrentUser.self, from: data)
                
            } catch {
                print("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            }.resume()
    }
    
    func addRestaurant(restaurant: Restaurant1, completion: @escaping (NetworkError?) -> Void) {
        
        
        guard let bearer = userController.currentUser?.token else {return}
        let url = baseURL.appendingPathComponent("api/restaurants")

        var request = URLRequest(url: url)
        

        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("\(bearer)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()

        do {
            request.httpBody = try encoder.encode(restaurant)
        } catch {
            NSLog("Error encoding restaurant: \(error)")
            completion(.otherError)
        }

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 201 {
                completion(.badAuth)
                return
            }

            if let _ = error {
                completion(.otherError)
                return
            }
            
            completion(nil)

            }.resume()
    }
    
    func fetchAllRestaurants(completion: @escaping (NetworkError?) -> Void) {
        
        guard let bearer = userController.currentUser?.token else {return}
        let allRestaurantsURL = baseURL.appendingPathComponent("api/restaurants")

        var request = URLRequest(url: allRestaurantsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("\(bearer)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.badAuth)
                return
            }

            if let _ = error {
                completion(.otherError)
                return
            }

            guard let data = data else {
                completion(.badData)
                return
            }

            let decoder = JSONDecoder()
            do {
                restaurantController.restaurants = try decoder.decode([Restaurant1].self, from: data)
                
                completion(nil)
            } catch {
                print("Error decoding restaurants: \(error)")
                completion(.noDecode)
                return
            }
            }.resume()
    }
    
    func updateRestaurantReview(review: Review1, completion: @escaping (NetworkError?) -> Void) {
        
        guard let restaurantID = review.restaurantId else {return}
        let url = baseURL.appendingPathComponent("api/reviews/restaurant/\(restaurantID)")
        guard let bearer = userController.currentUser?.token else {return}

        var request = URLRequest(url: url)

        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("\(bearer)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        do {
            request.httpBody = try encoder.encode(review)
        } catch {
            NSLog("Error encoding the restaurant update: \(error)")
            completion(.otherError)
        }

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 201 {
                completion(.otherError)
                return
            }

            if let _ = error {
                completion(.otherError)
                return
            }
            
            completion(nil)

            }.resume()
    }
    
    func fetchCurrentRestaurant(currentRestaurant: Restaurant1, completion: @escaping (NetworkError?) -> Void) {
        
        guard let bearer = userController.currentUser?.token else {return}
        guard let id = currentRestaurant.id else {return print("No id")}

        let restaurantURL = baseURL.appendingPathComponent("api/restaurants/\(id)")

        var request = URLRequest(url: restaurantURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("\(bearer)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.otherError)
                return
            }

            if let _ = error {
                completion(.otherError)
                return
            }

            guard let data = data else {
                completion(.badData)
                return
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                restaurantController.currentRestaurantDetails = try decoder.decode(Restaurant1.self, from: data)
                completion(nil)
            } catch {
                print("Error decoding current restaurant: \(error)")
                completion(.noDecode)
                return
            }
            }.resume()
    }
    
    func fetchCurrentRestaurantReviews(currentRestaurant: Restaurant1, completion: @escaping (NetworkError?) -> Void) {
        
        guard let bearer = userController.currentUser?.token else {return}
        guard let id = currentRestaurant.id else {return print("No id")}

        let restaurantURL = baseURL.appendingPathComponent("api/reviews/restaurant/\(id)")

        var request = URLRequest(url: restaurantURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("\(bearer)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.otherError)
                return
            }

            if let _ = error {
                completion(.otherError)
                return
            }

            guard let data = data else {
                completion(.badData)
                return
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                restaurantController.currentRestaurant?.reviews = try decoder.decode([Review1].self, from: data)
                completion(nil)
            } catch {
                print("Error decoding current restaurant: \(error)")
                completion(.noDecode)
                return
            }
            }.resume()
    }
    
    func fetchUserReviews(completion: @escaping (NetworkError?) -> Void) {
        
        guard let bearer = userController.currentUser?.token else {return}
        guard let userID = userController.currentUser?.userID else {return}
        let allRestaurantsURL = baseURL.appendingPathComponent("api/reviews/combo/\(userID)")

        var request = URLRequest(url: allRestaurantsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("\(bearer)", forHTTPHeaderField: "Authorization")
        

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.badAuth)
                return
            }

            if let _ = error {
                completion(.otherError)
                return
            }

            guard let data = data else {
                completion(.badData)
                return
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                userController.profileUser?.reviews = try decoder.decode([Review1].self, from: data)
                
                completion(nil)
            } catch {
                print("Error decoding reviews: \(error)")
                completion(.noDecode)
                return
            }
            }.resume()
    }
    
    func fetchUser(completion: @escaping (NetworkError?) -> Void) {
        
        guard let bearer = userController.currentUser?.token else {return}
        guard let userID = userController.currentUser?.userID else {return}
        let allRestaurantsURL = baseURL.appendingPathComponent("api/users/\(userID)")

        var request = URLRequest(url: allRestaurantsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("\(bearer)", forHTTPHeaderField: "Authorization")
        

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.badAuth)
                return
            }

            if let _ = error {
                completion(.otherError)
                return
            }

            guard let data = data else {
                completion(.badData)
                return
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                userController.profileUser = try decoder.decode(Foodie1.self, from: data)
                
                completion(nil)
            } catch {
                print("Error decoding reviews: \(error)")
                completion(.noDecode)
                return
            }
            }.resume()
    }
    
    func deleteReview(review: Review1, completion: @escaping (NetworkError?) -> Void ) {
        guard let bearer = userController.currentUser?.token else {return}
        guard let reviewID = review.id else {return}
            let allRestaurantsURL = baseURL.appendingPathComponent("api/reviews/\(reviewID)")

            var request = URLRequest(url: allRestaurantsURL)
            request.httpMethod = HTTPMethod.delete.rawValue
            request.addValue("\(bearer)", forHTTPHeaderField: "Authorization")
            

            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let response = response as? HTTPURLResponse,
                    response.statusCode != 200 {
                    completion(.badAuth)
                    return
                }

                if let _ = error {
                    completion(.otherError)
                    return
                }
                }.resume()
        
    }
}
