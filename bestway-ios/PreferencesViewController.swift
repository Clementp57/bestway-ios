//
//  PreferencesViewController.swift
//  bestway-ios
//
//  Created by Damien Bannerot on 20/10/2016.
//  Copyright © 2016 ESGI. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController {

	@IBOutlet weak var walkSwitch: UISwitch!
	@IBOutlet weak var cycleSwitch: UISwitch!
	@IBOutlet weak var carSwitch: UISwitch!
	@IBOutlet weak var busSwitch: UISwitch!
	@IBOutlet weak var subwaySwitch: UISwitch!
	@IBOutlet weak var tramSwitch: UISwitch!
	
	var preferences: BestwayClient.preferences? {
		didSet {
			self.walkSwitch.setOn(self.preferences!.walking, animated: true)
			self.cycleSwitch.setOn(self.preferences!.bicycling, animated: true)
			self.carSwitch.setOn(self.preferences!.driving, animated: true)
			self.busSwitch.setOn(self.preferences!.bus, animated: true)
			self.subwaySwitch.setOn(self.preferences!.subway, animated: true)
			self.tramSwitch.setOn(self.preferences!.tram, animated: true)
		}
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
		BestwayClient.shared.savePreferences(bike: self.cycleSwitch.isOn, bus: self.busSwitch.isOn, walk: self.walkSwitch.isOn, subway: self.subwaySwitch.isOn, car: self.carSwitch.isOn, tram: self.tramSwitch.isOn) { (success, message) in
			if success {
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
