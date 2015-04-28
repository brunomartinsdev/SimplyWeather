//
//  ViewController.swift
//  Weather
//
//  Created by Joyce Echessa on 10/16/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//
//  Changes and features to be added by Son Phan on 04/27/15
//  Open-source on Github.com/sonphanusa

import UIKit
import WeatherDataKit
import CoreLocation

class ViewController: WeatherDataViewController, CLLocationManagerDelegate{
    
    var defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.appcoda.weather")!
    var latLong = "41.3887242,-82.0722262"
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feelslikeLabel.text = "--"
        summaryLabel.text = "--"
        timeLabel.text = "--"
        humidityLabel.text = "--"
        precipitationLabel.text = "--"
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                NSLog("Error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let placem = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(placem)
            } else {
                NSLog("Placemarks = 0")
            }
        })
    }
    func displayLocationInfo(placemark: CLPlacemark) {
        if (placemark.name==nil) {
            checkForSetLocation()
            
            getWeatherData(latLong, completion: { (error) -> () in
                if error == nil {
                    self.updateData()
                }
            })
        }
            
        else{
            locationManager.stopUpdatingLocation()
            println(placemark.location.coordinate.latitude)
            println(placemark.location.coordinate.longitude)
            let newLatLong = String(stringInterpolationSegment: placemark.location.coordinate.latitude)+","+String(stringInterpolationSegment: placemark.location.coordinate.longitude)
            getWeatherData(newLatLong, completion: { (error) -> () in
                if error == nil {
                    self.locationLabel.text = placemark.locality
                    self.updateData()
                }
            })
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        checkForSetLocation()
        
        getWeatherData(latLong, completion: { (error) -> () in
            if error == nil {
                self.updateData()
            }
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        //        checkForSetLocation()
        //
        //        getWeatherData(latLong, completion: { (error) -> () in
        //            if error == nil {
        //                self.updateData()
        //            }
        //        })
    }
    
    func checkForSetLocation() {
        // hasSetLocation is set in NSUserDefaults to track whether the user has set any other location apart from My Location
        var hasSetOtherLocation: Bool? = defaults.boolForKey("hasSetLocation")
        if let hasSetLoc = hasSetOtherLocation {
            if (hasSetLoc == true) {
                let locationDict: NSDictionary? = defaults.objectForKey("locationData") as? NSDictionary
                if let dictionary = locationDict {
                    locationLabel.text = dictionary["name"] as? String
                    latLong = dictionary["latLong"] as! String
                }
            }
        }
    }
}

