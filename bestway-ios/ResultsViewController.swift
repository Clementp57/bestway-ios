//
//  ResultsViewController.swift
//  bestway-ios
//
//  Created by Damien Bannerot on 20/10/2016.
//  Copyright © 2016 ESGI. All rights reserved.
//

import UIKit
import MapKit

class ResultsViewController: UIViewController {
    
    var departurePoint: MKMapPoint?
    var arrivalPoint: MKMapPoint?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(departurePoint, arrivalPoint);

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: - Helpers
	
	
	
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
	
	// MARK: - UITableViewDelegate
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "resultCell") as? ResultTableViewCell
		if cell == nil {
			cell = ResultTableViewCell(style: .default, reuseIdentifier: "resultCell")
		}
		
		cell!.timeLabel.text = "test 2h19"
		return cell!
	}
	
	// MARK: - UITableViewDataSource
	
	
	
}
