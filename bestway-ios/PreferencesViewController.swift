//
//  PreferencesViewController.swift
//  bestway-ios
//
//  Created by Damien Bannerot on 20/10/2016.
//  Copyright © 2016 ESGI. All rights reserved.
//

import UIKit
import Foundation
import M13Checkbox

class PreferencesViewController: UIViewController {
    
    var walkCheckbox: M13Checkbox?;
    var cycleCheckbox: M13Checkbox?;
    var carCheckbox: M13Checkbox?;
    var busCheckbox: M13Checkbox?;
    var subwayCheckbox: M13Checkbox?;
    var tramCheckbox: M13Checkbox?;
    
    @IBOutlet var walkSwitchView: UIView!
    @IBOutlet var cycleSwitchView: UIView!
    @IBOutlet var carSwitchView: UIView!
    @IBOutlet var busSwitchView: UIView!
    @IBOutlet var subwaySwitchView: UIView!
    @IBOutlet var tramSwitchView: UIView!
    
    
	var preferences: BestwayClient.preferences? {
		didSet {
            self.walkCheckbox = self.initializeCheckbox(viewContainer: walkSwitchView, checked: self.preferences!.walking);
            self.cycleCheckbox = self.initializeCheckbox(viewContainer: cycleSwitchView, checked: self.preferences!.bicycling);
            self.carCheckbox = self.initializeCheckbox(viewContainer: carSwitchView, checked: self.preferences!.driving);
            self.busCheckbox = self.initializeCheckbox(viewContainer: busSwitchView, checked: self.preferences!.bus);
            self.subwayCheckbox = self.initializeCheckbox(viewContainer: subwaySwitchView, checked: self.preferences!.subway);
            self.tramCheckbox = self.initializeCheckbox(viewContainer: tramSwitchView, checked: self.preferences!.tram);
		}
	}
    
    private func initializeCheckbox(viewContainer : UIView, checked: Bool) -> M13Checkbox {
        let checkbox = M13Checkbox(frame: CGRect(x: 0.0, y:0.0, width: 40.0, height: 40.0))
        checkbox.stateChangeAnimation = .fill
        if(checked) {
            checkbox.setCheckState(.checked, animated: true)
        }
        viewContainer.addSubview(checkbox)
        return checkbox;
    }
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
		BestwayClient.shared.isLogged { (logged) in
			if !logged {
				let errorAlert = UIAlertController(title: "non conecté", message: nil, preferredStyle: .alert)
				errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
				self.present(errorAlert, animated: true, completion: nil)
			}
		}
		if let currentPreferences = BestwayClient.shared.currentPreferences {
			self.preferences = currentPreferences
		} else {
			BestwayClient.shared.getPreferences { (success, message, preferences) in
				if success {
					if let pref = preferences {
						self.preferences = pref
					} else {
						let errorAlert = UIAlertController(title: "Un problème est survenu", message: "préférences non récupérées", preferredStyle: .alert)
						errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
							self.navigationController?.popViewController(animated: true)
						}))
						self.present(errorAlert, animated: true, completion: nil)
					}
				} else {
					let errorAlert = UIAlertController(title: "Un problème est survenu", message: "préférences non récupérées", preferredStyle: .alert)
					errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
						//self.navigationController?.popViewController(animated: true)
					}))
					self.present(errorAlert, animated: true, completion: nil)
				}
			}
		}
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		self.savePreferences()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: - Actions
	
	@IBAction func saveParameters(_ sender: AnyObject) {
		self.savePreferences()
	}
	
	// MARK: - Helpers
	
	func savePreferences() {
		BestwayClient.shared.savePreferences(bike: self.cycleCheckbox?.checkState == .checked, bus: self.busCheckbox?.checkState == .checked, walk: self.walkCheckbox?.checkState == .checked, subway: self.subwayCheckbox?.checkState == .checked, car: self.carCheckbox?.checkState == .checked, tram: self.tramCheckbox?.checkState == .checked) { (success, message) in
			if success {
                debugPrint("Success");
				self.navigationController?.popViewController(animated: true)
			} else {
				let errorAlert = UIAlertController(title: "Un problème est survenu", message: "préférences non sauvegardées", preferredStyle: .alert)
				errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
				self.present(errorAlert, animated: true, completion: nil)
			}
		}
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
