//
//  AddCityViewController.swift
//  WeatherSwift
//
//  Created by Keshav on 10/8/17.
//  Copyright © 2017 Keshav. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
import CoreData


class AddCityViewController: UIViewController {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    
    @IBOutlet var citiesTable: UITableView! {
        didSet {
            citiesTable.isHidden = false
        }
    }
    //@IBOutlet var cityTextField: UITextField!
    
    var cities = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resultsViewController = GMSAutocompleteResultsViewController()
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        filter.country = "US"
        resultsViewController?.autocompleteFilter = filter
        resultsViewController?.delegate = self
    
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        
        let subView = UIView(frame: CGRect(x: 0, y: 65.0, width: 350.0, height: 45.0))

        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
    }
    
    @IBAction func addCity(_ sender: UIButton) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AddCityViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cities.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = citiesTable.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        cell.textLabel?.text = cities[indexPath.row]["city"] as? String
        return cell
    }
}

// Handle the user's selection.
extension AddCityViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        let lat = place.coordinate.latitude
        let long = place.coordinate.longitude
        print("Place lat: \(lat)")
        print("Place long: \(long)")
        
        cities.append(["city": place.name, "lat": lat, "long":long])
        let context = managedObjectContext()
        
        let location = Location(context: context)
        location.setValue(place.name, forKey: "city")
        location.setValue(Double(lat), forKey: "latitude")
        location.setValue(Double(long), forKey: "longitude")
        
        do {
            try context.save()
        } catch  {
            fatalError("Failure to save context: \(error)")
        }
        
        self.citiesTable.reloadData()
        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension AddCityViewController {
    
    func managedObjectContext() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        return context
    }
}
