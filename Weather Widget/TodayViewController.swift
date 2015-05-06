//
//  TodayViewController.swift
//  Weather Today
//
//  Created by Bruno Lima Martins on 5/5/15.
//  Copyright (c) 2015 Bruno Lima. All rights reserved.
//

import UIKit
import NotificationCenter
import WeatherDataKit
import CoreLocation

class TodayViewController: WeatherDataViewController, NCWidgetProviding, CLLocationManagerDelegate {
    
    let defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.bdevapps.WeatherCF")!
    var widgetExpanded = false
    var latLong = "41.3887242,-82.0722262"
    let locationManager = CLLocationManager()
    var locations  = ["name": "MyLocation", "latLong": ""]
    @IBOutlet weak var showMoreButton: UIButton!
    
    @IBOutlet weak var moreDetailsContainerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var helpView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        moreDetailsContainerHeightConstraint.constant = 0
        
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
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: "showDetails")
        helpView.addGestureRecognizer(gesture)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if(defaults.objectForKey("locationData")==nil){
            defaults.setObject(locations, forKey:"locationData")
            defaults.synchronize()
        }
        let locationData = defaults.objectForKey("locationData") as! [String:String]
        if("\(locationData.0)" == "[latLong: , name: MyLocation]"){
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
            })
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
    }
    
    func widgetMarginInsetsForProposedMarginInsets
        (defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
            return UIEdgeInsetsMake(0, 20, 0,0)
    }
    
    func showDetails(){
        if widgetExpanded {
            moreDetailsContainerHeightConstraint.constant = 0
            showMoreButton.transform = CGAffineTransformMakeRotation(0)
            widgetExpanded = false
        } else {
            moreDetailsContainerHeightConstraint.constant = 220
            showMoreButton.transform = CGAffineTransformMakeRotation(CGFloat(180.0 * M_PI/180.0))
            widgetExpanded = true
        }
    }
    
    @IBAction func showMore(sender: UIButton) {
    showDetails()
    
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
        }
            
        else{
            locationManager.stopUpdatingLocation()
            latLong = String(stringInterpolationSegment: placemark.location.coordinate.latitude)+","+String(stringInterpolationSegment: placemark.location.coordinate.longitude)
            
            getWeatherData(latLong, completion: { (error) -> () in
                if error == nil {
                    self.locationLabel.text = placemark.locality
                    self.updateData()
                }
            })
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
    }

    @IBAction func poweredButtonPressed(sender: UIButton) {
        if let context = extensionContext {
            
            
            let targetURL=NSURL(fileURLWithPath: "WeatherCF://")
            context.openURL(targetURL!, completionHandler: nil)
        }
    }
}
