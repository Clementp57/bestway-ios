//
//  LocationViewController.swift
//  bestway-ios
//
//  Created by Clément Peyrabere on 07/11/2016.
//  Copyright © 2016 ESGI. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class LocationViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    var locationManager: CLLocationManager?
    
    @IBOutlet var departureTextField: UITextField!
    @IBOutlet var arrivalTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        if location != nil {
            let region  = MKCoordinateRegionMakeWithDistance((location?.coordinate)!, 1500, 1500)
            self.mapView.setRegion(region, animated: true)
            
            let geocoder: CLGeocoder = CLGeocoder();
            geocoder.reverseGeocodeLocation(location!) { (placemark, error) in
                if error == nil {
                    self.locationManager?.stopUpdatingLocation()
                    self.departureTextField.text = (placemark?[0].subThoroughfare)! + " " + (placemark?[0].thoroughfare)!
                    
                    
                }
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
