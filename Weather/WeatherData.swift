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
    //let temperatureMinTimeStr: String
    let temperatureMax: Int
    //let temperatureMaxTimeStr: String
    let humidity: Double
    let precipProbability: Double
    let summary: String
    let windspeed: Int
    let feelslike: Int
    
    public init(weatherDictionary: NSDictionary) {
        let weather = weatherDictionary["currently"] as! NSDictionary
        let weatherdaily = weatherDictionary["daily"] as! NSDictionary
        
        temperature = weather["temperature"] as! Int
        //temperatureMin = weatherdaily["temperatureMin"] as Int
        //temperatureMax = weatherdaily["temperatureMax"] as Int
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
                //                dateFormatterTempMin.timeStyle = .ShortStyle
                dateFormatterTempMin.dateStyle = .ShortStyle
                let date = dateFormatterTempMin.stringFromDate(dateTempMin)
//                println(date)
//                println(dateFormatterTempMin.stringFromDate(NSDate()))
                if(date==dateFormatterTempMin.stringFromDate(NSDate())){
//                    println(record.objectForKey("temperatureMin"))
//                    println(record.objectForKey("temperatureMinTime"))
//                    println(record.objectForKey("temperatureMax"))
//                    println(record.objectForKey("temperatureMaxTime"))
//                    println((record.objectForKey("temperatureMin") as! NSNumber))
//                    println((record.objectForKey("temperatureMax") as! NSNumber))
//                    println((weather["temperature"] as! NSNumber))
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
        
        //let temperatureMinTime = weatherdaily["temperatureMinTime"] as Int
        //let timeIntervalTempMin = NSTimeInterval(temperatureMinTime)
        //let dateTempMin = NSDate(timeIntervalSince1970: timeIntervalTempMin)
        //let dateFormatterTempMin = NSDateFormatter()
        //dateFormatterTempMin.timeStyle = .ShortStyle
        
        //let temperatureMaxTime = weatherdaily["temperatureMaxTime"] as Int
        //let timeIntervalTempMax = NSTimeInterval(temperatureMaxTime)
        //let dateTempMax = NSDate(timeIntervalSince1970: timeIntervalTempMax)
        //let dateFormatterTempMax = NSDateFormatter()
        //dateFormatterTempMax.timeStyle = .ShortStyle
        
        currentTime = dateFormatter.stringFromDate(date)
        //temperatureMinTimeStr = dateFormatterTempMin.stringFromDate(dateTempMin)
        //temperatureMaxTimeStr = dateFormatterTempMax.stringFromDate(dateTempMax)
    }
    
    
    
}



