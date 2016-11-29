//
//  BestwayClient.swift
//  bestway-ios
//
//  Created by Clément Peyrabere on 07/11/2016.
//  Copyright © 2016 ESGI. All rights reserved.
//

import Foundation
import Alamofire
import MapKit

class BestwayClient {
    
    static var BASE_URL: String = "https://bestway.clementpeyrabere.net:8001";
    static var API_PREFIX: String = "/api/v1";
    
    // Mark : Public Routes
	static var LOGIN_ROUTE: String = BestwayClient.BASE_URL + "/public/login";
	static var REGISTER_ROUTE: String = BestwayClient.BASE_URL + "/public/register";
	static var TOKEN_CHECK_ROUTE: String = BestwayClient.BASE_URL + "/public/tokenCheck";
	
    // Mark : API Routes
    static var USER_PREF_ROUTE: String = BestwayClient.BASE_URL + BestwayClient.API_PREFIX + "/userPreferences";
    static var TRANSPORT_ROUTE: String = BestwayClient.BASE_URL + BestwayClient.API_PREFIX + "/transports";
    
    static let shared: BestwayClient = BestwayClient();
	
	static let userTokenDefaultKey: String = "BESTWAY_TOKEN"
	static let userIdDefaultKey: String = "BESTWAY_USER_ID"
	
	struct preferences {
		var walking: Bool
		var bicycling: Bool
		var bus: Bool
		var subway: Bool
		var driving: Bool
		var tram: Bool
		var train: Bool
	}
	
	var currentPreferences: BestwayClient.preferences?
    
    init() {
        
    }
    
    struct Session {
        var token = "";
        var userId = "";
    }
	
	public func login(email: String, password: String, completionHandler: @escaping (_ success: Bool, _ error: String) -> Void) {
		let parameters: Parameters = [
			"email": email,
			"password": password
		];
		Alamofire.request(BestwayClient.LOGIN_ROUTE, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
			debugPrint(response)
			if response.response!.statusCode >= 400 {
				completionHandler(false, "Informations invalides")
			} else {
				let data = response.result.value as! [String: AnyObject]
				UserDefaults.standard.set(data["token"]!, forKey: BestwayClient.userTokenDefaultKey)
				UserDefaults.standard.set(data["user"]!["_id"]!!, forKey: BestwayClient.userIdDefaultKey)
				completionHandler(true, "Success")
			}
			
		}
	}
	
	public func register(email: String, password: String, completionHandler: @escaping (_ success: Bool, _ error: String) -> Void) {
		let parameters: Parameters = [
			"email": email,
			"password": password
		];
		Alamofire.request(BestwayClient.REGISTER_ROUTE, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
			debugPrint(response)
			if response.response!.statusCode >= 400 {
				completionHandler(false, "Informations invalides")
			} else {
				let data = response.result.value as! [String: AnyObject]
				UserDefaults.standard.set(data["token"]! as! String, forKey: BestwayClient.userTokenDefaultKey)
				UserDefaults.standard.set(data["user"]!["_id"]!! as! String, forKey: BestwayClient.userIdDefaultKey)
				completionHandler(true, "Success")
			}
		}
	}
	
	public func isLogged(completionHandler: @escaping (_ success: Bool) -> Void) {
		if let token = UserDefaults.standard.object(forKey: BestwayClient.userTokenDefaultKey) as? String, let userId = UserDefaults.standard.object(forKey: BestwayClient.userIdDefaultKey) as? String {
			let headers: HTTPHeaders = [
				"x-access-token": token,
				"x-user-id": userId
			]
			Alamofire.request(BestwayClient.TOKEN_CHECK_ROUTE, method: .post, headers: headers).responseJSON { response in
				debugPrint(response)
				if response.response!.statusCode >= 400 {
					completionHandler(false)
				} else {
					completionHandler(true)
				}
			}
		} else {
			completionHandler(false)
		}

	}
	
	public func getPreferences(completionHandler: @escaping (_ success: Bool, _ error: String, _ preferences: preferences?) -> Void) {
		if let token = UserDefaults.standard.object(forKey: BestwayClient.userTokenDefaultKey) as? String, let userId = UserDefaults.standard.object(forKey: BestwayClient.userIdDefaultKey) as? String {
			let headers: HTTPHeaders = [
				"x-access-token": token,
				"x-user-id": userId,
				"Content-Type": "application/json"
			]
			Alamofire.request(BestwayClient.USER_PREF_ROUTE, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
				if response.response!.statusCode == 418 {
					self.currentPreferences = BestwayClient.preferences(walking: false, bicycling: false, bus: false, subway: false, driving: false, tram: false, train: false)
					completionHandler(true, "success", self.currentPreferences!)
				} else if response.response!.statusCode >= 400 {
					completionHandler(false, "Informations invalides", nil)
				} else {
					let data = response.result.value as! [String: AnyObject]
					if let preferences = data["userPreferences"] {
						if let walking = preferences["walking"] as? Bool, let bicycling = preferences["bicycling"] as? Bool, let bus = preferences["bus"] as? Bool, let subway = preferences["subway"] as? Bool, let driving = preferences["driving"] as? Bool, let tram = preferences["tram"] as? Bool {
							self.currentPreferences = BestwayClient.preferences(walking: walking, bicycling: bicycling, bus: bus, subway: subway, driving: driving, tram: tram, train: false)
							completionHandler(true, "success", self.currentPreferences!)
						} else {
							completionHandler(false, "error", nil)
						}
					} else {
						completionHandler(false, "error", nil)
					}
				}
			}
		} else {
			completionHandler(false, "error", nil)
		}
	}
	
	public func savePreferences(bike: Bool, bus: Bool, walk: Bool, subway: Bool, car: Bool, tram: Bool, completionHandler: @escaping (_ success: Bool, _ error: String) -> Void) {
		if let token = UserDefaults.standard.object(forKey: BestwayClient.userTokenDefaultKey) as? String, let userId = UserDefaults.standard.object(forKey: BestwayClient.userIdDefaultKey) as? String {
			let headers: HTTPHeaders = [
				"x-access-token": token,
				"x-user-id": userId,
				"Content-Type": "application/json"
			]
			let parameters: Parameters = [
				"bicycling": bike,
				"bus": bus,
				"walking": walk,
				"subway": subway,
				"driving": car,
				"tram": tram,
				"train": false
				]
			self.currentPreferences = BestwayClient.preferences(walking: walk, bicycling: bike, bus: bus, subway: subway, driving: car, tram: tram, train: false)
			Alamofire.request(BestwayClient.USER_PREF_ROUTE, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
				if response.response!.statusCode >= 400 {
					completionHandler(false, "Informations invalides")
				} else {
					completionHandler(true, "Informations bien enregistrées")
				}
			}
		}
	}
    
    public func getTransports(departure: MKMapPoint, arrival: MKMapPoint, completionHandler: @escaping (_ success: Bool, _ error: String, _ result: AnyObject) -> Void) {
        if let token = UserDefaults.standard.object(forKey: BestwayClient.userTokenDefaultKey) as? String, let userId = UserDefaults.standard.object(forKey: BestwayClient.userIdDefaultKey) as? String {
            let headers: HTTPHeaders = [
                "x-access-token": token,
                "x-user-id": userId,
                "Content-Type": "application/json"
            ]
            let parameters: Parameters = [
                "departure" : [ "latitude" : departure.x, "longitude": departure.y],
                "arrival": [ "latitude" : arrival.x, "longitude": arrival.y]
            ];
            debugPrint("PARAMETERS => ", parameters)
            Alamofire.request(BestwayClient.TRANSPORT_ROUTE, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                if response.response!.statusCode >= 400 {
                    completionHandler(false, "Error...", response as AnyObject)
                } else {
                    completionHandler(true, "", response as AnyObject)
                }
            }
        }
    }
}
