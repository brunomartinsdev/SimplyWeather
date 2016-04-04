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
        let defaults = NSUserDefaults.standardUserDefaults()
        let apiKey = "a6f20bd900f2753b6b107a1ab30bab5f"
        
        //        let apiKey = "94f0d4c9a77ee298721b483e88575206/"
        let baseUrl = NSURL(string: "https://api.forecast.io/forecast/"+apiKey+"/\(latLong)")
        let request = NSURLRequest(URL: baseUrl!)
        let task = session.dataTaskWithRequest(request) {[unowned self] data, response, error in
            if error == nil {

                let weatherDictionary: NSDictionary
               do { weatherDictionary = try (NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary)!
                    
//                    .JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments,error: &error) as? NSDictionary{
                
                    
                    defaults.setObject(weatherDictionary, forKey:"weatherDictionary")
                    defaults.synchronize()
                    let data = WeatherData(weatherDictionary: weatherDictionary)
                    completion(data: data, error: nil)
                    
               } catch _ {
                
                }
                
            } else {
                if(defaults.objectForKey("weatherDictionary")==nil){
                    completion(data: nil, error: error)
                }
                else{
                    let weatherDictionary = defaults.objectForKey("weatherDictionary") as! NSDictionary
                    let data = WeatherData(weatherDictionary: weatherDictionary)
                    completion(data: data, error: nil)
                }
                
            }
        }
        
        task.resume()
    }
    
    
}
