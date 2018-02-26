//
//  Forecast.swift
//  WeatherSwift
//
//  Created by Keshav on 8/20/17.
//  Copyright © 2017 Keshav. All rights reserved.
//

import Foundation
import CoreLocation

let kAPI_KEY:String = "7e16895662d3dc898860576f62722a97"

class Forecast: NSObject, CLLocationManagerDelegate {

    var locationManager : CLLocationManager?

    // This initalizer starts updating location to get the temperature data
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    func getTemperateForLocation(_ newLocation: CLLocation, completion: @escaping (Temperature)->Void) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(newLocation) { (placemarks, error) in
            guard let placemark = placemarks?.first else {
                return
            }
            
            let forcastURL = URL(string: "https://api.darksky.net/forecast/\(kAPI_KEY)/\(newLocation.coordinate.latitude),\(newLocation.coordinate.longitude)")
            let request = URLRequest(url: forcastURL!)
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                
                guard let data = data else { return }
                let parsedData = JSON(data: data)
                let tempData = Temperature(json: parsedData, city: placemark.locality!)
                    completion(tempData)
            })
            task.resume()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager?.stopUpdatingLocation()
        locationManager?.delegate = nil
        NotificationCenter.default.post(name:Notification.Name("DID_UPDATE_LOCATION"), object: nil, userInfo: ["location": locations[0]])
    }
}

