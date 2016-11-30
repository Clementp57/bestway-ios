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
	
	var results: [[String:Any]] = []
    
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	@IBOutlet weak var pagerScrollView: UIScrollView!
	@IBOutlet weak var firstTableView: UITableView!
	@IBOutlet weak var secondTableView: UITableView!
	@IBOutlet weak var thirdTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
		self.getResults()
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
	
	func getResults() {
		self.geocodeTrip(completionHandler: {(success, error) in
			if(success) {
				BestwayClient.shared.getTransports(departure: self.departurePoint, arrival: self.arrivalPoint, completionHandler: { (success, error, result) in
					if let array = result as? [[String:Any]] {
						self.results = array;
						self.firstTableView.reloadData()
						self.secondTableView.reloadData()
						self.thirdTableView.reloadData()
					}
					
				});
			} else {
				// Print message or go back
				self.navigationController!.popViewController(animated: true)
			}
			
		});
	}
	
	// MARK: - Actions
	
	@IBAction func clikedOnSegmentedControl(_ sender: UISegmentedControl) {
		if sender.selectedSegmentIndex == 0 {
			self.pagerScrollView.scrollRectToVisible(self.firstTableView.superview!.frame, animated: true)
		} else if sender.selectedSegmentIndex == 1 {
			self.pagerScrollView.scrollRectToVisible(self.secondTableView.superview!.frame, animated: true)
		} else if sender.selectedSegmentIndex == 2 {
			self.pagerScrollView.scrollRectToVisible(self.thirdTableView.superview!.frame, animated: true)
		}
	}
	
	
}

extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
	
	// MARK: - UITableViewDataSource
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.results.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "resultCell") as? ResultTableViewCell
		if cell == nil {
			cell = ResultTableViewCell(style: .default, reuseIdentifier: "resultCell")
		}
		
		var sortedArray: [[String:Any]] = []
		switch tableView {
		case self.firstTableView://time sorting
			if self.results.count > 0 {
				sortedArray = self.results.sorted {
					item1, item2 in
					let duration1 = item1["duration"] as! Int
					let duration2 = item2["duration"] as! Int
					return duration1 < duration2
				}
			}
		case self.secondTableView://ecology sorting, NOT WORKING, currently using time sorting
			if self.results.count > 0 {
				sortedArray = self.results.sorted {
					item1, item2 in
					let duration1 = item1["duration"] as! Int
					let duration2 = item2["duration"] as! Int
					return duration1 < duration2
				}
			}
		default://practical sorting
			if self.results.count > 0 {
				sortedArray = self.results.sorted {
					item1, item2 in
					let duration1 = item1["practicalIndex"] as! Int
					let duration2 = item2["practicalIndex"] as! Int
					return duration1 < duration2
				}
			}
		}
		
		let timeInMinutes: Int = (sortedArray[indexPath.row]["duration"] as! Int)/60
		let shownHours: Int = timeInMinutes/60
		let shownMinutes: Int = timeInMinutes-shownHours*60
		if shownMinutes<10 {
			cell!.timeLabel.text = "\(sortedArray[indexPath.row]["transport"]!) - \(shownHours)h0\(shownMinutes)"
		} else {
			cell!.timeLabel.text = "\(sortedArray[indexPath.row]["transport"]!) - \(shownHours)h\(shownMinutes)"
		}
		
		// TODO: - set UI for cells
		return cell!
	}
	
	// MARK: - UITableViewDelegate
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return self.firstTableView.frame.height/CGFloat(self.results.count)
	}
	
}

extension ResultsViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let pageWidth: CGFloat = scrollView.frame.size.width
		let fractionalPage: Float = Float(scrollView.contentOffset.x)/Float(pageWidth)
		print(fractionalPage)
		let page: Int = lround(Double(fractionalPage));
		self.segmentedControl.selectedSegmentIndex = page
	}
}
