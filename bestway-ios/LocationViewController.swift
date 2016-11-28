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

protocol PresentedViewControllerDelegate {
    func acceptData(data: String!)
}

class LocationViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, PresentedViewControllerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    var locationManager: CLLocationManager?
    
    @IBOutlet var departureTextField: UITextField!
    @IBOutlet var arrivalTextField: UITextField!
    @IBOutlet var goButton: UIButton!
    
    var departurePoint: MKMapPoint = MKMapPoint();
    var arrivalPoint: MKMapPoint = MKMapPoint();
    
    private var didEditArrival: Bool?
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.arrivalTextField {
            self.didEditArrival = true
        } else {
            self.didEditArrival = false
        }
        let autocompleteController = GooglePlacesAutocompleteViewController(apiKey: "AIzaSyC8q1InpJSdgvAcdywBKwi7f1uKv-ehbwQ")
        autocompleteController.modalPresentationStyle = .overCurrentContext
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func acceptData(data: String!) {
        if(didEditArrival)! {
            self.arrivalTextField.text = data
        } else {
            self.departureTextField.text = data
        }
        if(self.arrivalTextField.text != "" && self.departureTextField.text != "") {
            self.goButton.isEnabled = true;
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showResults") {
            let resultsController: ResultsViewController = segue.destination as! ResultsViewController
            resultsController.departurePoint = self.departurePoint
            resultsController.arrivalPoint = self.arrivalPoint
        }
    }
    
    @IBAction func onGoButtonPressed(_ sender: Any) {
        let geocoder: CLGeocoder = CLGeocoder();
        
        geocoder.geocodeAddressString(self.departureTextField.text!, completionHandler: { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    self.departurePoint.x = (placemark.location?.coordinate.latitude)!
                    self.departurePoint.y = (placemark.location?.coordinate.latitude)!
                }
                
                geocoder.geocodeAddressString(self.arrivalTextField.text!, completionHandler: { (placemarks, error) in
                    if error == nil {
                        if let placemark = placemarks?[0] {
                            self.arrivalPoint.x = (placemark.location?.coordinate.latitude)!
                            self.arrivalPoint.y = (placemark.location?.coordinate.latitude)!
                        }
                        
                        self.performSegue(withIdentifier: "showResults", sender: self)
                    }
                });
                
            }
        });
    }
    
}
