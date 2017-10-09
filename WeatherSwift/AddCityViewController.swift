//
//  AddCityViewController.swift
//  WeatherSwift
//
//  Created by Keshav on 10/8/17.
//  Copyright © 2017 Keshav. All rights reserved.
//

import UIKit
import CoreLocation

class AddCityViewController: UIViewController {

    @IBOutlet var citiesTable: UITableView! {
        didSet {
            citiesTable.isHidden = true
        }
    }
    @IBOutlet var cityTextField: UITextField!
    
    var cities = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addCity(_ sender: UIButton) {
        
        guard let city = cityTextField.text else { return }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(city) { (placemarks, error) in
            print(error)
            print(placemarks)
            if let _ = error {
                let alert = UIAlertController(title: "Error", message: "Unable to find this location", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
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
        
        var cell:UITableViewCell = citiesTable.dequeueReusableCell(withIdentifier: "CityCell") as! UITableViewCell
        cell.textLabel?.text = "Los Angeles"
        
        return cell
    }
}
