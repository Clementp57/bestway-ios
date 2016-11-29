//
//  InitialViewController.swift
//  bestway-ios
//
//  Created by Damien Bannerot on 29/11/2016.
//  Copyright © 2016 ESGI. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
	
	let autoLog: Bool = true
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
    }

	override func viewDidAppear(_ animated: Bool) {
		if self.autoLog {
			BestwayClient.shared.isLogged { (success) in
				if success {
					self.performSegue(withIdentifier: "initialToLocationSegue", sender: self)
				} else {
					self.performSegue(withIdentifier: "initialToLoginSegue", sender: self)
				}
			}
		} else {
			self.performSegue(withIdentifier: "initialToLoginSegue", sender: self)
		}
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
