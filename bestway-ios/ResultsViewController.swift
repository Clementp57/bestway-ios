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
	@IBOutlet weak var thirdTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
		self.getResults()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: - Helpers
	
	func getResults() {
        BestwayClient.shared.getTransports(departure: self.departurePoint, arrival: self.arrivalPoint, completionHandler: { (success, error, result) in
            if var array = result as? [[String:Any]] {
                for (i, entry) in array.enumerated() {
                    if entry["transport"] as! String == "train" {
                        array.remove(at: i)
                    }
                }
                self.results = array;
                self.firstTableView.reloadData()
                self.thirdTableView.reloadData()
            }
		});
	}
	
	// MARK: - Actions
	
	@IBAction func clikedOnSegmentedControl(_ sender: UISegmentedControl) {
		if sender.selectedSegmentIndex == 0 {
			self.pagerScrollView.scrollRectToVisible(self.firstTableView.superview!.frame, animated: true)
		} else if sender.selectedSegmentIndex == 1 {
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
        
        var transportLabel: String = "";
        var transportIcon: UIImage = UIImage();
        
        switch(sortedArray[indexPath.row]["transport"] as! String) {
        case "driving":
            transportLabel = "Voiture"
            transportIcon = #imageLiteral(resourceName: "car")
            break
        case "bus":
            transportLabel = "Bus"
            transportIcon = #imageLiteral(resourceName: "bus")
            break
        case "subway":
            transportLabel = "Métro"
            transportIcon = #imageLiteral(resourceName: "metro")
            
            //if((sortedArray[indexPath.row]["transport"]["lines"] as! [Any]).count > 0) {
                
            //}
            
            break
        case "tram":
            transportLabel = "Tramway"
            transportIcon = #imageLiteral(resourceName: "train")
            break
        case "bicycling":
            transportLabel = "Vélo"
            transportIcon = #imageLiteral(resourceName: "bicycle")
            break
        case "walking":
            transportLabel = "Marche"
            transportIcon = #imageLiteral(resourceName: "shoe")
            break
        default:
            break
        }
        
        cell!.transportLabel.text = transportLabel
        cell!.iconImageView.image = transportIcon
		
		let timeInMinutes: Int = (sortedArray[indexPath.row]["duration"] as! Int)/60
		let shownHours: Int = timeInMinutes/60
		let shownMinutes: Int = timeInMinutes-shownHours*60
		if shownHours < 1 {
			cell!.timeLabel.text = "\(shownMinutes)min"
		} else if shownMinutes<10 {
			cell!.timeLabel.text = "\(shownHours)h0\(shownMinutes)"
		} else {
			cell!.timeLabel.text = "\(shownHours)h\(shownMinutes)"
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
		let page: Int = lround(Double(fractionalPage));
		self.segmentedControl.selectedSegmentIndex = page
	}
}
