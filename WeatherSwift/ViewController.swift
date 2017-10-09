//
//  ViewController.swift
//  WeatherSwift
//
//  Created by Keshav on 6/11/17.
//  Copyright © 2017 Keshav. All rights reserved.
//

import UIKit
import CoreLocation

let kAPI_KEY:String = "7e16895662d3dc898860576f62722a97"


class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var summaryLabel: UILabel! {
        didSet {
            summaryLabel.text = ""
        }
    }
    @IBOutlet var tempLabel: UILabel! {
        didSet {
            tempLabel.text = ""
        }
    }
    
    var locationManager : CLLocationManager?
    @IBOutlet var activityIndicator : UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
    
    @IBOutlet var sevenDayTable: UITableView! {
        didSet {
            sevenDayTable.isHidden = true
        }
    }
    var sevenDayData = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        
        activityIndicator.color = .darkGray
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func getCurrentTemperature(location: CLLocation) {
        Forecast.sharedInstance.getTemperateForLocation(location) { [unowned self] (tempDict) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.title = tempDict["city"] as? String
                self.tempLabel?.text = tempDict["temp"] as? String
                self.summaryLabel?.text = tempDict["summary"] as? String
                if let sevenData = tempDict["sevenDays"] as? [[String:String]] {
                    self.sevenDayData = sevenData
                }

                self.sevenDayTable.isHidden = false
                self.sevenDayTable.reloadData()
            }
        }
    }
    
    @IBAction func showSavedCities() {
        let addCityVC:AddCityViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddCityViewController") as! AddCityViewController

        self.present(addCityVC, animated: true, completion: nil)
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sevenDayData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "SevenDayCell", for: indexPath) as! SevenDayCell
        
        cell.weekdayLabel.text = sevenDayData[indexPath.row]["weekday"]
        cell.minTempLabel.text = sevenDayData[indexPath.row]["minTemp"]
        cell.maxTempLabel.text = sevenDayData[indexPath.row]["maxTemp"]
        
        return cell
    }
}


extension ViewController {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager?.stopUpdatingLocation()
        locationManager?.delegate = nil
        print(locations[0])
        getCurrentTemperature(location: locations[0])
    }
}

