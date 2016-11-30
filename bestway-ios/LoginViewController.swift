//
//  LoginViewController.swift
//  bestway-ios
//
//  Created by Damien Bannerot on 20/10/2016.
//  Copyright © 2016 ESGI. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak var logTypeSegmentedControl: UISegmentedControl!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var sendButton: UIButton!
    @IBOutlet var backgroundImage: UIImageView!
	
	let autoLog: Bool = false
	
    override func viewDidLoad() {
        backgroundImage.image = UIImage(named: "backgroundImage")
            //?.blurryImage(blurRadius: 1.5);
        
		NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardAppeared), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardDismissed), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		
		self.emailTextField.delegate = self
		self.passwordTextField.delegate = self
		if self.autoLog {
			BestwayClient.shared.isLogged { (success) in
				if success {
					self.performSegue(withIdentifier: "LoginVCToNavigationController", sender: self)
				}
			}
		}
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
		if isLogin {// connexion
			BestwayClient.shared.login(email: email, password: password, completionHandler: { (success, error) in
				if success {
					print("SUCCES")
					self.performSegue(withIdentifier: "LoginVCToNavigationController", sender: self)
				} else {
					print("ERROR"+error)
					let errorAlert = UIAlertController(title: error, message: nil, preferredStyle: .alert)
					errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
						self.emailTextField.becomeFirstResponder()
					}))
					self.present(errorAlert, animated: true, completion: nil)
				}
			})
		} else {// inscription
			BestwayClient.shared.register(email: email, password: password, completionHandler: { (success, error) in
				if success {
					print("SUCCES")
					self.performSegue(withIdentifier: "LoginVCToNavigationController", sender: self)
				} else {
					print("ERROR"+error)
					let errorAlert = UIAlertController(title: error, message: nil, preferredStyle: .alert)
					errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
						self.emailTextField.becomeFirstResponder()
					}))
					self.present(errorAlert, animated: true, completion: nil)
				}
			})
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
					self.sendRequest(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, isLogin: true)
				} else {// inscription
					self.sendRequest(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, isLogin: false)
				}
			} else {
				let passwordAlert = UIAlertController(title: "Mot de passe", message: "Vous devez remplir le champs mot de passe !", preferredStyle: .alert)
				passwordAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
					self.passwordTextField.becomeFirstResponder()
				}))
				self.present(passwordAlert, animated: true, completion: nil)
			}
		} else {
			let usernameAlert = UIAlertController(title: "Email", message: "Vous devez remplir le champs email !", preferredStyle: .alert)
			usernameAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
				self.emailTextField.becomeFirstResponder()
			}))
			self.present(usernameAlert, animated: true, completion: nil)
		}
	}
	
	@IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
		self.view.endEditing(true)
	}
	
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		
    }
	
	// MARK: - UITextFieldDelegate
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == self.emailTextField {
			self.passwordTextField.becomeFirstResponder()
		} else if textField == self.passwordTextField {
			self.tapOnSendButton(self.sendButton)
		}
		return true
	}

}
