//
//  Temperature.swift
//  WeatherSwift
//
//  Created by Keshav on 2/11/18.
//  Copyright © 2018 Keshav. All rights reserved.
//

import Foundation

struct Temperature {
    let location : String?
    let currentTemp: String?
    let summary: String?
    var sevenDay: [Weekday]?
    
    init(json: JSON, city: String?) {
        
        location = city
        
        if let temp = json["currently"]["apparentTemperature"].double {
            currentTemp = String(format: "%.0f°F", temp)
        } else {
            currentTemp = "Unavailable"
        }
        
        
        summary = json["currently"]["summary"].string
        
        if let weeklyData = json["daily"]["data"].array {
            sevenDay = weeklyData.map({ (dailyTemp) -> Weekday in
                return Weekday(day: dailyTemp)
            })
        }
    }
}
