//
//  LoginViewController.swift
//  bestway-ios
//
//  Created by Damien Bannerot on 20/10/2016.
//  Copyright © 2016 ESGI. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

	@IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak var logTypeSegmentedControl: UISegmentedControl!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var sendButton: UIButton!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardAppeared), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardDismissed), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: - Helpers
	
	func initializeUI() {
		self.emailTextField.text = ""
		self.passwordTextField.text = ""
	}

	func keyboardAppeared(notification: NSNotification) {
		if let userInfo = notification.userInfo {
			let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
			UIView.animate(withDuration: 0.2, animations: {
				self.scrollViewBottomConstraint.constant = keyboardHeight
				self.view.layoutIfNeeded()
			});
			//			self.scrollView.scrollRectToVisible(CGRect.init(x: 0, y: self.scrollView.contentOffset.y+keyboardHeight, width: self.scrollView.frame.width, height: self.scrollView.frame.height), animated: true)
		}
		
	}
	
	func keyboardDismissed(notification: NSNotification) {
		self.scrollViewBottomConstraint.constant = 0
	}
	
	func sendRequest(withEmail email: String, password: String, isLogin: Bool) {
		let json = ["email":email , "password": password]
		if isLogin {// connexion
			do {
				let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
				
				// create post request
				let url = URL(string: "bestway.clementpeyrabere.net/public/login")
				var request = URLRequest(url: url!)
				request.httpMethod = "POST"
				
				// insert json data to the request
				request.httpBody = jsonData
				
				
				let task = URLSession.shared.dataTask(with: request){ data,response,error in
					if error != nil{
						print(error?.localizedDescription)
						return
					}
					do {
						let responseJSON = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
						print(responseJSON)
						//TODO
					} catch {
						print("error")
					}
				}
				
				task.resume()
			} catch {
				print("error")
			}
		} else {// inscription
			
		}
	}
	
	
	// MARK: - Actions
	
	@IBAction func changeSegmentedControlValue(_ sender: UISegmentedControl) {
		if sender.selectedSegmentIndex == 0 {
			
		} else if sender.selectedSegmentIndex == 1 {
			
		}
	}
	
	@IBAction func tapOnSendButton(_ sender: UIButton) {
		if self.emailTextField.text != "" {
			if self.passwordTextField.text != "" {
				if self.logTypeSegmentedControl.selectedSegmentIndex == 0 {// connexion
					
				} else {// inscription
					
				}
			}
			let passwordAlert = UIAlertController(title: "Mot de passe", message: "Vous devez remplir le champs mot de passe !", preferredStyle: .alert)
			passwordAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
				self.passwordTextField.becomeFirstResponder()
			}))
			self.present(passwordAlert, animated: true, completion: nil)
		}
		let usernameAlert = UIAlertController(title: "Email", message: "Vous devez remplir le champs email !", preferredStyle: .alert)
		usernameAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
			self.emailTextField.becomeFirstResponder()
		}))
		self.present(usernameAlert, animated: true, completion: nil)
	}
	
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		
    }
	
	

}
