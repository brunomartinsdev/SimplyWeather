//
//  ViewController.swift
//  Weather CF
//
//  Created by Bruno Lima Martins on 5/5/15.
//  Copyright (c) 2015 Bruno Lima. All rights reserved.
//

import UIKit
import WeatherDataKit
import CoreLocation

class ViewController: WeatherDataViewController, CLLocationManagerDelegate, UIScrollViewDelegate{
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var latLong = "41.3887242,-82.0722262"
    let locationManager = CLLocationManager()
    let locations  = ["name": "My Location", "latLong": ""]
    var dict = Dictionary<Int, [String:String]>()
    
    @IBAction func poweredButtonPressed(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string:"http://forecast.io/")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.action_notification_WatchButton(_:)), name:"updateFetchLogNotificationIdentifier", object: nil)
        
        dict.removeAll(keepCapacity: false)
        view.backgroundColor = UIColor(hue:0.58, saturation:0.92, brightness:0.84, alpha:1)
        feelslikeLabel.text = "--"
        summaryLabel.text = "--"
        timeLabel.text = "--"
        humidityLabel.text = "--"
        precipitationLabel.text = "--"
        temperatureLabel.text =  "--"
        windspeedLabel.text =  "--"
        temperatureMinLabel.text =  "--"
        temperatureMaxLabel.text =  "--"
        locationLabel.text =  "--"
        if(defaults.objectForKey("type")==nil){
            defaults.setObject(1 as Int?, forKey:"type")
            defaults.synchronize()
        }
        self.navigationController?.topViewController!.title = "Weather Lite"
        scrollView.contentSize = CGSizeMake(0, 400)
        scrollView.contentOffset = CGPointMake(0,0)
        if let locationData = defaults.objectForKey("locationData") as? [String:String]{
            if("\(locationData.first)" == "[latLong: , name: My Location]"){
                locationLabel.text = self.defaults.objectForKey("placemark.locality") as? String
            }
            else{
                let locationDict: NSDictionary? = defaults.objectForKey("locationData") as? NSDictionary
                if let dictionary = locationDict {
                    locationLabel.text = dictionary["name"] as? String
                }
                
            }
        }
        
        
        self.updateData()
        
    }
    
    
    func action_notification_WatchButton(notification:NSNotification) {
        
        update()
    }
    
    func update(){
        if(defaults.objectForKey("locationData")==nil){
            defaults.setObject(locations, forKey:"locationData")
            defaults.synchronize()
            dict[0] = locations//.first
            let dataSave = NSKeyedArchiver.archivedDataWithRootObject(dict)
            defaults.setObject(dataSave, forKey:"locationList")
            defaults.synchronize()
        }
        
        
        let locationData = defaults.objectForKey("locationData") as! [String:String]
        if("\(locationData.first)" == "[latLong: , name: My Location]"){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        else{
            let locationDict: NSDictionary? = defaults.objectForKey("locationData") as? NSDictionary
            if let dictionary = locationDict {
                locationLabel.text = dictionary["name"] as? String
                latLong = dictionary["latLong"] as! String
            }
            getWeatherData(latLong, completion: { (error) -> () in
                if error == nil {
                    self.updateData()
                }
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(0 as Int?, forKey:"refresh")
                defaults.synchronize()
            })
            
        }
        
    }
    
    
    func refresh(){
        let locationData = defaults.objectForKey("locationData") as! [String:String]
        if("\(locationData.first)" == "[latLong: , name: My Location]"){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        else{
            let locationDict: NSDictionary? = defaults.objectForKey("locationData") as? NSDictionary
            if let dictionary = locationDict {
                locationLabel.text = dictionary["name"] as? String
                latLong = dictionary["latLong"] as! String
            }
            getWeatherData(latLong, completion: { (error) -> () in
                if error == nil {
                    self.updateData()
                    
                }
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(0 as Int?, forKey:"refresh")
                defaults.synchronize()
            })
            
        }
    }
    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            print("info")
            
            if (error != nil) {
                NSLog("Error" + error!.localizedDescription)
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(0 as Int?, forKey:"refresh")
                defaults.synchronize()
                return
            }
            
            if placemarks!.count > 0 {
                let placem = placemarks![0] 
                self.displayLocationInfo(placem)
            } else {
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(0 as Int?, forKey:"refresh")
                defaults.synchronize()
                NSLog("Placemarks = 0")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
        
        if (placemark.name==nil) {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(0 as Int?, forKey:"refresh")
            defaults.synchronize()
        }
            
        else{
            locationManager.stopUpdatingLocation()
            print(placemark.location!.coordinate.latitude)
            print(placemark.location!.coordinate.longitude)
            latLong = String(stringInterpolationSegment: placemark.location!.coordinate.latitude)+","+String(stringInterpolationSegment: placemark.location!.coordinate.longitude)
            getWeatherData(latLong, completion: { (error) -> () in
                if error == nil {
                    print(placemark.locality)
                    self.locationLabel.text = placemark.locality
                    self.defaults.setObject(placemark.locality as String?, forKey:"placemark.locality")
                    self.defaults.synchronize()
                    self.updateData()
                    
                }
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(0 as Int?, forKey:"refresh")
                defaults.synchronize()
            })
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(0 as Int?, forKey:"refresh")
        defaults.synchronize()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad{
            scrollView.frame = CGRectMake(scrollView.frame.origin.x,320, UIScreen.mainScreen().bounds.width-scrollView.frame.origin.x, UIScreen.mainScreen().bounds.height-320)
            
        }else{
            scrollView.frame = CGRectMake(scrollView.frame.origin.x,240, UIScreen.mainScreen().bounds.width-scrollView.frame.origin.x, UIScreen.mainScreen().bounds.height-240)
        }
        scrollView.contentSize = CGSizeMake(0, 400)
        
    }
    
}

