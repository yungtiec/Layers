//
//  DailyWeather.swift
//  ScrollviewTest
//
//  Created by Yung-Tien Chu on 11/23/15.
//  Copyright © 2015 Yung-Tien Chu. All rights reserved.
//

import Foundation
import UIKit

struct DailyWeather {
    
    let maxTemperature: Int?
    let minTemperature: Int?
    let summary: String?
    var day: String?
    var icon: UIImage? = UIImage(named: "default.png")
    var timezone: String?
    let dateFormatter = NSDateFormatter()
    
    
    init(dailyWeatherDictionary: [String: AnyObject], inTimezone: String) {
        maxTemperature = dailyWeatherDictionary["temperatureMax"] as? Int
        minTemperature = dailyWeatherDictionary["temperatureMin"] as? Int
        summary = dailyWeatherDictionary["summary"] as? String
        timezone = inTimezone
        if let time = dailyWeatherDictionary["time"] as? Double {
            day = "\(weekdayStringFromTime(time)), \(dayStringFromTime(time))"
        }
        if let iconString = dailyWeatherDictionary["icon"] as? String,
            let iconEnum = Icon(rawValue: iconString) {
                (icon, _) = iconEnum.toImage()
        }
        
    }
    
    func weekdayStringFromTime(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)
        dateFormatter.timeZone = NSTimeZone(name: "\(timezone)")
        dateFormatter.dateFormat = "E"
        return dateFormatter.stringFromDate(date)
    }
    
    func dayStringFromTime(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)
        dateFormatter.timeZone = NSTimeZone(name: "\(timezone)")
        dateFormatter.dateFormat = "MMM dd"
        return dateFormatter.stringFromDate(date)
    }
    
    
}