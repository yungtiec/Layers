//
//  Forecast.swift
//  ScrollviewTest
//
//  Created by Yung-Tien Chu on 11/23/15.
//  Copyright © 2015 Yung-Tien Chu. All rights reserved.
//

import Foundation
struct Forecast {
    var currentWeather: CurrentWeather?
    var weekly: [DailyWeather] = []
    var hourly: [HourlyWeather] = []
    var timezone: String?
    var lat: Double?
    var lng: Double?
    
    init(weatherDictionary: [String: AnyObject]) {
        if let currentWeatherDictionary = weatherDictionary["currently"] as? [String: AnyObject] {
            currentWeather = CurrentWeather(weatherDictionary: currentWeatherDictionary)
        }
        if let dailyWeatherArray = weatherDictionary["daily"] as? [String: AnyObject] {
            
            timezone = dailyWeatherArray["0"] as! String // 0 -> need to fix the key in key-value pair returned from php
            if let dailyWeatherArray = weatherDictionary["daily"]?["data"] as? [[String: AnyObject]] {
                for dailyWeather in dailyWeatherArray {
                    let daily = DailyWeather(dailyWeatherDictionary: dailyWeather, inTimezone: "\(timezone)")
                    weekly.append(daily)
                }
            }
        }
        if let hourlyWeatherArray = weatherDictionary["hourly"]?["data"] as? [[String: AnyObject]] {
            for hourlyWeather in hourlyWeatherArray {
                let hour = HourlyWeather(hourlyWeatherDictionary: hourlyWeather, inTimezone: timezone!)
                hourly.append(hour)
            }
        }
        lat = weatherDictionary["latitude"] as? Double
        lng = weatherDictionary["longitude"] as? Double
        
    }
}