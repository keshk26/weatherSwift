//
//  Helpers+Extenstions.swift
//  WeatherSwift
//
//  Created by Keshav on 2/11/18.
//  Copyright © 2018 Keshav. All rights reserved.
//

import Foundation

extension Date {
    func weekDayFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self as Date)
    }
}

extension Double {
    func convertToDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
}
