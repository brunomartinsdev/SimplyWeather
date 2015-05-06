//
//  WeatherService.swift
//  Weather
//
//  Created by Joyce Echessa on 10/16/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//
//  Changes and features to be added by Son Phan on 04/27/15
//  Open-source on Github.com/sonphanusa

import Foundation

class WeatherService {
    
    typealias WeatherDataCompletionBlock = (data: WeatherData?, error: NSError?) -> ()
    
    let session: NSURLSession
    
    class var sharedInstance: WeatherService {
    struct Singleton {
        static let instance = WeatherService()
        }
        return Singleton.instance
    }
    
    init() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: configuration)
    }
    
    func fetchWeatherData(latLong: String, completion: WeatherDataCompletionBlock) {
        
        let baseUrl = NSURL(string: "https://api.forecast.io/forecast/94f0d4c9a77ee298721b483e88575206/\(latLong)")
        let request = NSURLRequest(URL: baseUrl!)
        let task = session.dataTaskWithRequest(request) {[unowned self] data, response, error in
            if error == nil {
                var jsonError: NSError?
                if (jsonError == nil) {
                    let weatherDictionary = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.AllowFragments, error: &jsonError) as! NSDictionary
                    
                    let data = WeatherData(weatherDictionary: weatherDictionary)
                    completion(data: data, error: nil)
                } else {
                    completion(data: nil, error: jsonError)
                }
            } else {
                completion(data: nil, error: error)
            }
        }
        
        task.resume()
    }
    
}



