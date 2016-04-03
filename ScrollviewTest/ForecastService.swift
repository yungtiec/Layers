//
//  ForecastService.swift
//  Stormy
//
//  Created by Yung-Tien Chu on 11/15/15.
//  Copyright © 2015 Yung-Tien Chu. All rights reserved.
//

import Foundation

struct ForecastService {
    
    let queryParameter: String
    let forecastBaseURL: NSURL?
    
    init(address: String, city: String, state: String, unit: String) {
        
        let queryParameterTemp = "address=" + address + "&city=" + city  + "&state=" + state + "&degree=" + unit
        self.queryParameter = queryParameterTemp.stringByReplacingOccurrencesOfString(" ", withString: "+")
        self.forecastBaseURL = NSURL(string: "http://awscsci571-env.elasticbeanstalk.com/")
    }
    
    func getForecast(completion: (Forecast? -> Void)) {
        if let forecastURL = NSURL(string: "forecast.php?\(queryParameter)", relativeToURL: forecastBaseURL) {
            
            let networkOperation = NetworkOperation(url: forecastURL)
            
            networkOperation.downloadJSONFromURL {
                (let JSONDictionary) in
                let forecast = Forecast(weatherDictionary: JSONDictionary!)
                completion(forecast)
    
            }
            
        } else {
            print("Could not construct a valid URL")
        }
    
    }
    
    
}