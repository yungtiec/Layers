//
//  CurrentWeather.swift
//  Stormy
//
//  Created by Yung-Tien Chu on 11/15/15.
//  Copyright © 2015 Yung-Tien Chu. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeather {
    
    let temperature: Int?
    var temperatureMin: Int?
    var temperatureMax: Int?
    let humidity: Int?
    var precipitation: String?
    var chanceRain: Int?
    let windSpeed: Double?
    let dewPoint: Double?
    let visibility: Double?
    let sunriseTime: String?
    let sunsetTime: String?
    let summary: String?
    let iconString: String?
    var background: UIImage? = UIImage(named: "cloudy-bg.png")
    let city: String?
    let state: String?
    
    // constructor
    init(weatherDictionary: [String: AnyObject]) {
        
        temperature = weatherDictionary["temperature"] as? Int
        humidity = weatherDictionary["humidity"] as? Int
        if let temperatureMinFloat = weatherDictionary["temperatureMin"] as? Double {
            temperatureMin = Int(temperatureMinFloat)
        }
        if let temperatureMaxFloat = weatherDictionary["temperatureMax"] as? Double {
            temperatureMax = Int(temperatureMaxFloat)
        }
        if let precipProbabilityFloat = weatherDictionary["precipitation"] as? Double {
            if (precipProbabilityFloat >= 0 && precipProbabilityFloat < 0.002) {
                precipitation = "None"
            } else if (precipProbabilityFloat >= 0.002 && precipProbabilityFloat < 0.017) {
                precipitation = "Very Light";
            } else if (precipProbabilityFloat >= 0.017 && precipProbabilityFloat < 0.01) {
                precipitation = "Light";
            } else if (precipProbabilityFloat >= 0.01 && precipProbabilityFloat < 0.4) {
                precipitation = "Moderate";
            } else if (precipProbabilityFloat >= 0.4) {
                precipitation = "Heavy";
            }
        } else {
            precipitation = nil
        }
        if let chanceRainFloat = weatherDictionary["chanceRain"] as? Double {
            chanceRain = Int(chanceRainFloat)
        } else {
            chanceRain = nil
        }
        windSpeed = weatherDictionary["windSpeed"] as? Double
        dewPoint = weatherDictionary["dewPoint"] as? Double
        visibility = weatherDictionary["visibility"] as? Double
        sunriseTime = weatherDictionary["sunrise"] as? String
        sunsetTime = weatherDictionary["sunset"] as? String
        summary = weatherDictionary["summary"] as? String
        city = weatherDictionary["city"] as? String
        state = weatherDictionary["state"] as? String
        iconString = weatherDictionary["iconImg"] as? String
        if let bgString = weatherDictionary["icon"] as? String,
            let iconEnum = Icon(rawValue: bgString) {
                (_, background) = iconEnum.toImage()
        }
    }
    
}