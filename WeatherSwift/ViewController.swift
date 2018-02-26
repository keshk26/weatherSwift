//
//  ViewController.swift
//  WeatherSwift
//
//  Created by Keshav on 6/11/17.
//  Copyright © 2017 Keshav. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

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
    
    var forecast : Forecast?
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
    var sevenDayData : [Weekday]?
    var selectedLocation : CLLocation?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateForcast(notfication:)), name:Notification.Name("DID_UPDATE_LOCATION"), object: nil)
        
        activityIndicator.color = .darkGray
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        if let selectedLocation = selectedLocation {
            activityIndicator.startAnimating()
            getCurrentTemperature(location: selectedLocation)
        } else {
            // Initalize Forecast class to get current location
            forecast = Forecast()
        }
    }
    
    func getCurrentTemperature(location: CLLocation) {
        forecast?.getTemperateForLocation(location) { [unowned self] (temperature) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.title = temperature.location
                self.tempLabel?.text = temperature.currentTemp
                self.summaryLabel?.text = temperature.summary
                self.sevenDayData = temperature.sevenDay
                self.sevenDayTable.isHidden = false
                self.sevenDayTable.reloadData()
            }
        }
    }
    
    func updateForcast(notfication: NSNotification) {
        guard let userInfo = notfication.userInfo as? Dictionary<String, CLLocation>, let updatedLocation = userInfo["location"] else {
            return
        }
        getCurrentTemperature(location: updatedLocation)
    }
    
    @IBAction func showSavedCities() {
        let addCityVC:AddCityViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddCityViewController") as! AddCityViewController

        self.present(addCityVC, animated: true, completion: nil)
    }
    
    @IBAction func getWeatherAtLocale(_ sender: Any) {
        // Reinitalize forecast class to update to current location
        forecast = Forecast()
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sevenDayData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "SevenDayCell", for: indexPath) as! SevenDayCell
        
        cell.weekdayLabel.text = sevenDayData?[indexPath.row].weekday
        cell.minTempLabel.text = sevenDayData?[indexPath.row].minTemp
        cell.maxTempLabel.text = sevenDayData?[indexPath.row].maxTemp
        
        return cell
    }
}

