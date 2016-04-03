//
//  NetworkOperation.swift
//  Stormy
//
//  Created by Yung-Tien Chu on 11/15/15.
//  Copyright © 2015 Yung-Tien Chu. All rights reserved.
//

import Foundation


class NetworkOperation {
    
    lazy var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session: NSURLSession = NSURLSession(configuration: self.config)
    let queryURL: NSURL
    
    typealias JSONDictionaryCompletion = ([String: AnyObject]?) -> Void
    
    // initialize url
    init(url: NSURL) {
        self.queryURL = url
    }
    
    func downloadJSONFromURL(completion:JSONDictionaryCompletion) {
        
        let request: NSURLRequest = NSURLRequest(URL: queryURL)
        let dataTask = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            
            // 1. check http response for successful GET request
            if let httpResponse = response as? NSHTTPURLResponse {
                switch(httpResponse.statusCode) {
                case 200:
                    // 2. create JSON object with data
                    do {
                        let jsonDictionary =  try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String: AnyObject]
                        completion(jsonDictionary)
                    } catch let error {
                        print("JSON serialization failed. Error:\(error)")
                    }
                    
                default:
                    print("GET request not successful. HTTP status code: \(httpResponse.statusCode)")
                }
            } else {
                print("Error: Not a valid HTTP response")
            }
            
        }
        
        dataTask.resume()
    }
}