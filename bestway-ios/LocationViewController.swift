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

class LocationViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, PresentedViewControllerDelegate, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    var locationManager: CLLocationManager?
    
    @IBOutlet var departureTextField: UITextField!
    @IBOutlet var arrivalTextField: UITextField!
    @IBOutlet var goButton: UIButton!
    
    var departureAnnotation: MKPointAnnotation = MKPointAnnotation();
    var arrivalAnnotation: MKPointAnnotation = MKPointAnnotation();
    
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
	
	// MARK: - CLLocationManagerDelegate
	
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        if location != nil {
            let region  = MKCoordinateRegionMakeWithDistance((location?.coordinate)!, 1500, 1500)
            departureAnnotation.coordinate.latitude = (location?.coordinate.latitude)!
            departureAnnotation.coordinate.longitude = (location?.coordinate.longitude)!
            
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
	
	// MARK: - UITextFielDelegate
	
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
	
	// MARK: - Helpers
	
    func acceptData(data: String!) {
        if(didEditArrival)! {
            self.arrivalTextField.text = data
        } else {
            self.departureTextField.text = data
        }
        self.updateMap(didEditArrival!);
    }
    
    func updateMap(_ didEditArrival: Bool) -> Void {
        let address = didEditArrival ? self.arrivalTextField.text! : self.departureTextField.text!;
        let geocoder = CLGeocoder();
        geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let point = MKPointAnnotation();
                    point.coordinate.latitude = (placemark.location?.coordinate.latitude)!
                    point.coordinate.longitude = (placemark.location?.coordinate.longitude)!
                    point.title = address
                    
                    if(didEditArrival) {
                        self.mapView.removeAnnotation(self.arrivalAnnotation);
                        self.arrivalAnnotation.coordinate.latitude = point.coordinate.latitude
                        self.arrivalAnnotation.coordinate.longitude = point.coordinate.longitude
                        self.mapView.addAnnotation(self.arrivalAnnotation);
                    } else {
                        self.mapView.removeAnnotation(self.departureAnnotation);
                        self.departureAnnotation.coordinate.latitude = point.coordinate.latitude
                        self.departureAnnotation.coordinate.longitude = point.coordinate.longitude
                        self.mapView.addAnnotation(self.departureAnnotation);
                    }
                    
                    if(self.departureTextField.text! != "" && self.arrivalTextField.text! != "") {
                        let center = MKPointAnnotation();
                        center.coordinate.latitude = (self.departureAnnotation.coordinate.latitude + self.arrivalAnnotation.coordinate.latitude) / 2
                        center.coordinate.longitude = (self.departureAnnotation.coordinate.longitude + self.arrivalAnnotation.coordinate.longitude) / 2
                        
                        let distanceMeters = CLLocation(latitude: self.departureAnnotation.coordinate.latitude, longitude: self.departureAnnotation.coordinate.longitude).distance(from: CLLocation(latitude: self.arrivalAnnotation.coordinate.latitude, longitude: self.arrivalAnnotation.coordinate.longitude)) + 1500
                        
                        let region = MKCoordinateRegionMakeWithDistance(center.coordinate, distanceMeters, distanceMeters)
                        self.mapView.setRegion(region, animated: true)
                        
                        self.goButton.isEnabled = true;
                    } else {
                        self.goButton.isEnabled = false;
                    }
                }
            }
        });
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showResults") {
            let resultsController: ResultsViewController = segue.destination as! ResultsViewController
            resultsController.departurePoint = MKMapPoint(x: self.departureAnnotation.coordinate.latitude, y: self.departureAnnotation.coordinate.longitude)
            resultsController.arrivalPoint = MKMapPoint(x: self.arrivalAnnotation.coordinate.latitude, y: self.arrivalAnnotation.coordinate.longitude)
        }
    }
    
}
