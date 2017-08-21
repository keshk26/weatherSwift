//
//  Forecast.swift
//  WeatherSwift
//
//  Created by Keshav on 8/20/17.
//  Copyright © 2017 Keshav. All rights reserved.
//

import Foundation
import CoreLocation

class Forecast: NSObject, CLLocationManagerDelegate {

    static let sharedInstance = Forecast()
    
    func getTemperateForLocation(_ newLocation: CLLocation, completion: @escaping ([String:Any])->Void) {
        
        var locationData = [String:Any]()
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(newLocation) { [unowned self] (placemarks, error) in
            guard let placemark = placemarks?.first else {
                return
            }
            
            locationData["city"] = placemark.locality
            
            let forcastURL = URL(string: "https://api.darksky.net/forecast/\(kAPI_KEY)/\(newLocation.coordinate.latitude),\(newLocation.coordinate.longitude)")
            let request = URLRequest(url: forcastURL!)
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                
                    guard let data = data else { return }
                    let parsedData = JSON(data: data)
                    completion(self.processTempData(jsonDict: parsedData))
            })
            task.resume()
        }
    }
    
    func processTempData(jsonDict: JSON) -> [String:Any] {
        
        var tempData = [String: Any]()
        // Current temp
        let currentDict = jsonDict["currently"]
        if let currentTemp = currentDict["apparentTemperature"].double {
            tempData["temp"] = String(format: "%.0f°F", currentTemp)
        } else {
            tempData["temp"] = "Unavailable"
        }
        
        if let currentSummary = currentDict["summary"].string {
            tempData["summary"] = currentSummary
        } else {
            tempData["summary"] = "Unavailable"
        }
        
        // 7-day forecast
        guard let sevenDayData = jsonDict["daily"]["data"].array else {
            return tempData
        }
        var sevenDay = [[String:Any]]()

        for forecastDict in sevenDayData {
            
            let date = NSDate.init(timeIntervalSinceReferenceDate: TimeInterval(forecastDict["time"].intValue))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            
            var dict = [String: Any]()
            dict["weekday"] = dateFormatter.string(from: date as Date)
            dict["minTemp"] = String(format: "%.0f°", forecastDict["apparentTemperatureMin"].doubleValue)
            dict["maxTemp"] = String(format: "%.0f°", forecastDict["apparentTemperatureMax"].doubleValue)
            sevenDay.append(dict)
        }
        
        tempData["sevenDays"] = sevenDay
        return tempData
    }
}

