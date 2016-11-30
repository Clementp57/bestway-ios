//
//  GooglePlacesAutocompleteViewController.swift
//  bestway-ios
//
//  Created by Clément Peyrabere on 08/11/2016.
//  Copyright © 2016 ESGI. All rights reserved.
//

import UIKit
import Alamofire

class GooglePlacesAutocompleteViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    static var BASE_GOOGLE_PLACES_API_URL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?";
    var delegate : PresentedViewControllerDelegate?
    
    @IBOutlet var uiSearchBar: UISearchBar!
    private var API_KEY: String?
    @IBOutlet var searchResultsTableView: UITableView!
    //@IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var navigationBar: UINavigationBar!
    
    var searchResults: [String] = [String]();
    
    convenience init(apiKey: String) {
        self.init()
        self.API_KEY = apiKey
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSearchBar.delegate = self;
        searchResultsTableView.delegate = self;
        searchResultsTableView.dataSource = self;
        searchResultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        uiSearchBar.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getPlaces(searchText: searchText);
    }
    
    func getPlaces(searchText: String) {
        searchResults.removeAll(keepingCapacity: false)
        
        var requestURL: String = GooglePlacesAutocompleteViewController.BASE_GOOGLE_PLACES_API_URL
        requestURL += "key=" + API_KEY!
        requestURL += "&input=" + searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        requestURL += "&location=48.859690,2.344776"
        requestURL += "&radius=50000"
        
        Alamofire.request(requestURL).responseJSON(completionHandler: { response in
            let data = response.result.value as! [String: AnyObject]
            let predictions = data["predictions"]
            for prediction in predictions as! [AnyObject] {
                self.searchResults.append(prediction["description"]! as! String)
            }
            DispatchQueue.main.async {
                self.searchResultsTableView.reloadData()
            }
        });
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.acceptData(data: self.searchResults[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "DefaultCell";
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let searchResult = self.searchResults[indexPath.row]
        
        cell.textLabel?.text = searchResult
        return cell
    }
}
