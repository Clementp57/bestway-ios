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
    
    var departureAddress: String?
    var arrivalAddress: String?
    
    var departurePoint: MKMapPoint = MKMapPoint();
    var arrivalPoint: MKMapPoint = MKMapPoint();
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.geocodeTrip(completionHandler: {(success, error) in
            if(success) {
                BestwayClient.shared.getTransports(departure: self.departurePoint, arrival: self.arrivalPoint, completionHandler: { (success, error, result) in
                    debugPrint(result);
                });
            } else {
                // Print message or go back
            }
            
        });
    }
    
    private func geocodeTrip(completionHandler: @escaping (_ success: Bool, _ error: String) -> Void) -> Void {
        let geocoder: CLGeocoder = CLGeocoder();
        geocoder.geocodeAddressString(self.departureAddress!, completionHandler: { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    self.departurePoint.x = (placemark.location?.coordinate.latitude)!
                    self.departurePoint.y = (placemark.location?.coordinate.longitude)!
                }
                
                geocoder.geocodeAddressString(self.arrivalAddress!, completionHandler: { (placemarks, error) in
                    if error == nil {
                        if let placemark = placemarks?[0] {
                            self.arrivalPoint.x = (placemark.location?.coordinate.latitude)!
                            self.arrivalPoint.y = (placemark.location?.coordinate.longitude)!
                        }
                        
                        completionHandler(true, "");
                    } else {
                        completionHandler(false, error.debugDescription);
                    }
                });
                
            } else {
                completionHandler(false, error.debugDescription);
            }
        });
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
