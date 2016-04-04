//
//  WeatherDataViewController.swift
//  Weather
//
//  Created by Joyce Echessa on 10/16/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//
//  Changes and features to be added by Son Phan on 04/27/15
//  Open-source on Github.com/sonphanusa

import UIKit

public class WeatherDataViewController: UIViewController {
    
    @IBOutlet public var temperatureLabel: UILabel!
    @IBOutlet public var feelslikeLabel: UILabel!
    @IBOutlet public var windspeedLabel: UILabel!
    @IBOutlet public var summaryLabel: UILabel!
    @IBOutlet public var timeLabel: UILabel!
    @IBOutlet public var humidityLabel: UILabel!
    @IBOutlet public var precipitationLabel: UILabel!
    @IBOutlet public var locationLabel: UILabel!
    @IBOutlet public var temperatureMaxLabel: UILabel!
    @IBOutlet public var temperatureMinLabel: UILabel!
    
    
    public var weatherData: WeatherData?
    
    @IBOutlet public var scrollView: UIScrollView!
    
    
    
    public func updateData() {
        if(self.defaultsx.objectForKey("weatherDictionary")==nil){}
        else{
            let data = WeatherData(weatherDictionary: self.defaultsx.objectForKey("weatherDictionary") as! NSDictionary)
            pasteData(data)
        }
        
        
        
    }
    let defaultsx = NSUserDefaults.standardUserDefaults()
    func pasteData(unwrappedWD:WeatherData){
        self.temperatureLabel.layer.cornerRadius = 60
        self.temperatureLabel.layer.borderColor = UIColor.whiteColor().CGColor
        self.temperatureLabel.layer.borderWidth = 2.0
        self.windspeedLabel.text =  "\(unwrappedWD.windspeed)"+" mph"
        self.summaryLabel.text =  "\(unwrappedWD.summary)"
        self.timeLabel.text =  "\(unwrappedWD.currentTime)"
        self.humidityLabel.text =  "\(unwrappedWD.humidity)"
        self.precipitationLabel.text =  "\(unwrappedWD.precipProbability)"
        let defaults = NSUserDefaults.standardUserDefaults()
        if(defaults.objectForKey("type")==nil){
            defaults.setObject(1 as Int?, forKey:"type")
            defaults.synchronize()
        }
        if(defaults.objectForKey("type") as! Int==1){
            self.temperatureMinLabel.text =  "\(unwrappedWD.temperatureMin)"+"/"+"\(unwrappedWD.temperatureMax)"
            self.temperatureMaxLabel.text =  "\(unwrappedWD.temperatureMax)"
            self.temperatureLabel.text =  "\(unwrappedWD.temperature)"
            self.feelslikeLabel.text =  "\(unwrappedWD.feelslike)"
        }else{
            self.temperatureMinLabel.text =  "\(farenheitToCelsius(unwrappedWD.temperatureMin))"+"/"+"\(farenheitToCelsius(unwrappedWD.temperatureMax))"
            self.temperatureMaxLabel.text =  "\(farenheitToCelsius(unwrappedWD.temperatureMax))"
            self.temperatureLabel.text =  "\(farenheitToCelsius(unwrappedWD.temperature))"
            self.feelslikeLabel.text =  "\(farenheitToCelsius(unwrappedWD.feelslike))"
        }

        
    }
    
    
    public func getWeatherData(latLong: String, completion: (error: NSError?) -> ()) {
        WeatherService.sharedInstance.fetchWeatherData(latLong, completion: { (data, error) -> () in
            dispatch_async(dispatch_get_main_queue()) {
                self.weatherData = data
                completion(error: error)
            }
        })
    }
    func farenheitToCelsius(temperature:NSNumber)->Int{
        
        let temperature = (Double(temperature)-32)/1.8
        return Int(temperature)
    }
}

