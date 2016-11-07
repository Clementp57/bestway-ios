//
//  BestwayClient.swift
//  bestway-ios
//
//  Created by Clément Peyrabere on 07/11/2016.
//  Copyright © 2016 ESGI. All rights reserved.
//

import Foundation
import Alamofire

class BestwayClient {
    
    static var BASE_URL: String = "https://bestway.clementpeyrabere.net";
    static var API_PREFIX: String = "/api/v1";
    
    // Mark : Public Routes
    static var LOGIN_ROUTE: String = BestwayClient.BASE_URL + "/public/login";
    static var REGISTER_ROUTE: String = BestwayClient.BASE_URL + "/public/register";
    
    // Mark : API Routes
    static var USER_PREF_ROUTE: String = BestwayClient.BASE_URL + BestwayClient.API_PREFIX + "/userPreferences";
    static var TRANSPORT_ROUTE: String = BestwayClient.BASE_URL + BestwayClient.API_PREFIX + "/transports";
    
    static let shared: BestwayClient = BestwayClient();
	
	static let tokenUserDefaultKey: String = "BESTWAY_TOKEN"
    
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
				UserDefaults.standard.set(data["token"]!, forKey: BestwayClient.tokenUserDefaultKey)
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
				UserDefaults.standard.set(data["token"]!, forKey: BestwayClient.tokenUserDefaultKey)
				completionHandler(true, "Success")
			}
		}
	}
	
	
	
}
