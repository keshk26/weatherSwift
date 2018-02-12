//
//  Weekday.swift
//  WeatherSwift
//
//  Created by Keshav on 2/11/18.
//  Copyright © 2018 Keshav. All rights reserved.
//

import Foundation

struct Weekday {
    let weekday : String?
    let minTemp : String?
    let maxTemp : String?
    
    init(day: JSON) {
        let time = day["time"].double
        let date = time?.convertToDate()
        weekday = date?.weekDayFormat()
        minTemp = String(format: "%.0f°", day["apparentTemperatureMin"].doubleValue)
        maxTemp = String(format: "%.0f°", day["apparentTemperatureMax"].doubleValue)
    }
}
