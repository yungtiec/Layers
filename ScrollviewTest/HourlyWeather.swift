//
//  HourlyWeather.swift
//  ScrollviewTest
//
//  Created by Yung-Tien Chu on 11/23/15.
//  Copyright © 2015 Yung-Tien Chu. All rights reserved.
//

import Foundation
import UIKit

struct HourlyWeather {
    
    let temperature: Int?
    var hour: String?
    var icon: UIImage? = UIImage(named: "default.png")
    let timezone: String?
    let dateFormatter = NSDateFormatter()
    
    init(hourlyWeatherDictionary: [String: AnyObject], inTimezone: String) {
        temperature = hourlyWeatherDictionary["temperature"] as? Int
        timezone = inTimezone
        if let time = hourlyWeatherDictionary["time"] as? Double {
            hour = timeStringFromUnixTime(time)
        }
        if let iconString = hourlyWeatherDictionary["icon"] as? String,
            let iconEnum = Icon(rawValue: iconString) {
                (icon, _) = iconEnum.toImage()
        }
    }
    
    func timeStringFromUnixTime(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)
        // Returns date formatted as 12 hour time.
        let inTimezone = self.timezone!
            dateFormatter.timeZone = NSTimeZone(name: inTimezone)
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.stringFromDate(date)
    }
}