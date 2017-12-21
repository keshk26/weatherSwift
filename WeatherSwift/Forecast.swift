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

    static let sharedInstance = Forecast()
    
    func getTemperateForLocation(_ newLocation: CLLocation, completion: @escaping ([String:Any])->Void) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(newLocation) { [unowned self] (placemarks, error) in
            guard let placemark = placemarks?.first else {
                return
            }
            
            let forcastURL = URL(string: "https://api.darksky.net/forecast/\(kAPI_KEY)/\(newLocation.coordinate.latitude),\(newLocation.coordinate.longitude)")
            let request = URLRequest(url: forcastURL!)
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                
                    guard let data = data else { return }
                    let parsedData = JSON(data: data)
                    var tempData = self.processTempData(jsonDict: parsedData)
                    tempData["city"] = placemark.locality
                    completion(tempData)
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
            var dict = [String: Any]()
            dict["weekday"] = weekDayFormat(time: forecastDict["time"].doubleValue)
            dict["minTemp"] = String(format: "%.0f°", forecastDict["apparentTemperatureMin"].doubleValue)
            dict["maxTemp"] = String(format: "%.0f°", forecastDict["apparentTemperatureMax"].doubleValue)
            sevenDay.append(dict)
        }
        
        tempData["sevenDays"] = sevenDay
        return tempData
    }
}

extension Forecast {
    func weekDayFormat(time: Double) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(time))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date as Date)
    }
}

