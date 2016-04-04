//
//  WeatherData.swift
//  Weather
//
//  Created by Joyce Echessa on 10/16/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//
//  Changes and features to be added by Son Phan on 04/27/15
//  Open-source on Github.com/sonphanusa

import Foundation

public class WeatherData: NSObject {
    
    let currentTime: String
    let temperature: Int
    let temperatureMin: Int
    let temperatureMax: Int
    let humidity: Double
    let precipProbability: Double
    let summary: String
    let windspeed: Int
    let feelslike: Int
    
    public init(weatherDictionary: NSDictionary) {
        let weather = weatherDictionary["currently"] as! NSDictionary
        
        let weatherdaily = weatherDictionary["daily"] as! NSDictionary
        
        temperature = weather["temperature"] as! Int
        feelslike = weather["apparentTemperature"] as! Int
        humidity = weather["humidity"] as! Double
        precipProbability = weather["precipProbability"] as! Double
        summary = weather["summary"] as! String
        windspeed = weather["windSpeed"] as! Int
        var tMin = 0
        var tMax = 0

        
        
        if let temp = weatherdaily["data"] as? NSArray{
            for record in temp{
                
                let temperatureMinTime = record.objectForKey("temperatureMinTime") as! NSNumber
                let timeIntervalTempMin = NSTimeInterval(temperatureMinTime)
                let dateTempMin = NSDate(timeIntervalSince1970: timeIntervalTempMin)
                let dateFormatterTempMin = NSDateFormatter()
                dateFormatterTempMin.dateStyle = .ShortStyle
                let date = dateFormatterTempMin.stringFromDate(dateTempMin)
                if(date==dateFormatterTempMin.stringFromDate(NSDate())){
                    tMin = Int(record.objectForKey("temperatureMin") as! NSNumber)
                    tMax = Int(record.objectForKey("temperatureMax") as! NSNumber)
                }
            }
            
        }
        temperatureMin = tMin
        temperatureMax = tMax
        let time = weather["time"] as! Int
        let timeInterval = NSTimeInterval(time)
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        currentTime = dateFormatter.stringFromDate(date)
        
    }
    

    
}



