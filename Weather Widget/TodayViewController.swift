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
//import Fabric
//import Crashlytics
class TodayViewController: WeatherDataViewController, NCWidgetProviding, CLLocationManagerDelegate{//,UIGestureRecognizerDelegate {
    
    let defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.bdevapps.WeatherCF")!
    var widgetExpanded = false
    var latLong = "41.3887242,-82.0722262"
    let locationManager = CLLocationManager()
    var locations  = ["name": "My Location", "latLong": ""]
    let gesture = UITapGestureRecognizer()
    @IBOutlet weak var showMoreButton: UIButton!
    
    @IBOutlet weak var moreDetailsContainerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var newLabel: UILabel!
    @IBOutlet var todayView: UIView!
    @IBOutlet var helpView: UILabel!
    var otherView = UIView()
    
//    override func viewWillDisappear(animated: Bool) {
//        for record in labels{
//            record.removeFromSuperview()
//            
//        }
//        
//        for record in labels1{
//            record.removeFromSuperview()
//            //            viewx.addSubview(record)
//        }
//        
//        for record in labels2{
//            record.removeFromSuperview()
//            //            viewx.addSubview(record)
//        }
//        
//        for record in labels3{
//            record.removeFromSuperview()
//            //            viewx.addSubview(record)
//        }
//        viewx.removeFromSuperview()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        Fabric.with([Crashlytics()])
//        tapView.frame = CGRectMake(UIScreen.mainScreen().bounds.width/2,0, UIScreen.mainScreen().bounds.width/2,230)

        pageControl = UIPageControl(frame:CGRectMake(0, 180, view.frame.size.width, 5))
        pageControl.numberOfPages = 2
        nextButton = UIButton(frame:CGRectMake(0, 180, view.frame.size.width, 5))
        nextButton.addTarget(self, action: #selector(TodayViewController.nextPage), forControlEvents: UIControlEvents.TouchUpInside)
        nextButton.setImage(UIImage(named: "right")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
        nextButton.tintColor = UIColor.grayColor()
        previousButton = UIButton(frame:CGRectMake(0, 180, view.frame.size.width, 5))
        previousButton.addTarget(self, action: #selector(TodayViewController.backPage), forControlEvents: UIControlEvents.TouchUpInside)
        previousButton.setImage(UIImage(named: "left"), forState: UIControlState.Normal)
        view.addSubview(pageControl)
        view.addSubview(nextButton)
//        moreDetailsContainerHeightConstraint.constant = 0
        
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
        gesture.addTarget(self, action: #selector(TodayViewController.showDetails))
        helpView.addGestureRecognizer(gesture)
        helpView.userInteractionEnabled = true
        
//        view.addSubview(tapView)
//        view.bringSubviewToFront(newLabel)
//        view.bringSubviewToFront(showMoreButton)
        
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
        self.preferredContentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, 40)
  
//        tapView.backgroundColor  = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
//        view.sendSubviewToBack(tapView)
//        (helpView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        configView()
        updateWeather()

        
    }
    
    func updateWeather(){
        if(defaults.objectForKey("locationData")==nil){
            defaults.setObject(locations, forKey:"locationData")
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
            })
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets
        (defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
            return UIEdgeInsetsMake(0, 20, 0,0)
    }

    func showDetails(){
//        gesture.addTarget(self, action: "nextPage")
        if widgetExpanded {
//            viewx.removeFromSuperview()
//            moreDetailsContainerHeightConstraint.constant = 0
            showMoreButton.transform = CGAffineTransformMakeRotation(0)
            self.preferredContentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, 40)
            widgetExpanded = false
//            tapView.removeGestureRecognizer(gesture)
        } else {
            pageControl.currentPage = 2
            nextPage()
//            self.tapView.addGestureRecognizer(gesture)
//            tapView.userInteractionEnabled = true

//            moreDetailsContainerHeightConstraint.constant = 220
            self.preferredContentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, 250)
            showMoreButton.transform = CGAffineTransformMakeRotation(CGFloat(180.0 * M_PI/180.0))
            widgetExpanded = true
        }

    }
    
    @IBAction func showMore(sender: UIButton) {
        showDetails()
        
    }
    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
//                NSLog("Error" + error.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let placem = placemarks![0]
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
            latLong = String(stringInterpolationSegment: placemark.location!.coordinate.latitude)+","+String(stringInterpolationSegment: placemark.location!.coordinate.longitude)
            
            getWeatherData(latLong, completion: { (error) -> () in
                if error == nil {
                    self.locationLabel.text = placemark.locality
                    self.updateData()
                }
            })
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    }
    
    @IBAction func poweredButtonPressed(sender: UIButton) {
        if let context = extensionContext {
            
            
            let targetURL=NSURL(fileURLWithPath: "WeatherCF://")
            context.openURL(targetURL, completionHandler: nil)
        }
    }
    
    var pageControl = UIPageControl()
    var nextButton = UIButton()
    var previousButton = UIButton()
//    var tapView = UILabel()
    override func viewDidLayoutSubviews() {
        pageControl.frame = CGRectMake(0, 240, view.frame.size.width, 5)
        nextButton.frame = CGRectMake(view.frame.size.width-35, 110, 30, 30)
        
        
    }
   

    
    var page = 0
    func nextPage(){
        
        //        pageControl.currentPage = 1
        //        configView()
        //        view.addSubview(viewx)
        //        nextDay(page)
        if(pageControl.currentPage==0){
            
            todayView.hidden = true
            pageControl.currentPage = 1
            nextButton.transform = CGAffineTransformMakeRotation(CGFloat(180.0 * M_PI/180.0))
            viewx.hidden = false
            let origin:CGFloat = 5
            let h = 27
            //CGFloat(i*22)
            viewx.frame = CGRectMake(0,todayView.frame.origin.y, UIScreen.mainScreen().bounds.width, todayView.frame.height+30.0)
            var i = 0
            for record in labels{
                record.frame = CGRectMake(origin+0,origin+CGFloat(i*h),viewx.frame.width/7, 21)
                record.hidden = false

                i += 1
            }
            
            i = 0
            for record in labels1{
                record.frame = CGRectMake(50,origin+CGFloat(i*h),viewx.frame.width-viewx.frame.width/7, 21)
                record.hidden = false
                i += 1
            }
            i = 0
            for record in labels2{
                record.frame = CGRectMake(180,origin+CGFloat(i*h),viewx.frame.width-viewx.frame.width/7, 21)
                record.hidden = false
                i += 1
            }
            i = 0
            
            for record in labels3{
                record.frame = CGRectMake(230,origin+CGFloat(i*h),viewx.frame.width-viewx.frame.width/7, 21)
                record.hidden = false
                i += 1
            }
             view.addSubview(viewx)
            nextDay()
//            view.bringSubviewToFront(nextButton).

        }
        else{
            viewx.hidden = true
            viewx.removeFromSuperview()
            todayView.hidden = false
            pageControl.currentPage = 0
            nextButton.transform = CGAffineTransformMakeRotation(0)
            
        }
                    view.bringSubviewToFront(newLabel)
        //        widgetExpanded = true
    }
    
  

    
    
    func backPage(){
        pageControl.currentPage = 0
//        viewx.removeFromSuperview()
        
    }
    
    
    
    func farenheittoCelsius(temperature:NSNumber)->Int{
        
        let temperature = (Double(temperature)-32)/1.8
        return Int(temperature)
    }
    
//    func nextDay(pageNumber:Int){
//        if(self.defaults.objectForKey("weatherDictionary")==nil){
//            
//        }
//        else{
//            let weatherDictionary = self.defaults.objectForKey("weatherDictionary") as! NSDictionary
//            let data = WeatherData(weatherDictionary: weatherDictionary)
//            let weatherdaily = weatherDictionary["daily"] as! NSDictionary
//            var tMin = 0
//            var i = 0
//            if let temp = weatherdaily["data"] as? NSArray{
//                
//                for record in temp{
//                    if (i<labels.count){
//                        let temperatureMinTime = record.objectForKey("time") as! NSNumber
//                        let timeInterval = NSTimeInterval(temperatureMinTime)
//                        let date = NSDate(timeIntervalSince1970: timeInterval)
//                        let dateFormatter = NSDateFormatter()
//                        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
//                        dateFormatter.dateStyle = .ShortStyle
//                        let nextDay = NSDate().dateByAddingTimeInterval(60*60*24*Double(i))
//                        if(dateFormatter.stringFromDate(date)==dateFormatter.stringFromDate(nextDay)){
//                            println(date)
//                            //                        summaryLabel.text = record.objectForKey("summary") as? String
//                            //                        windspeedLabel.text =  String(record.objectForKey("windSpeed") as! Int)
//                            var tempMinMax = ""
//                            
//                            if(defaults.objectForKey("type")==nil){
//                                defaults.setObject(1 as Int?, forKey:"type")
//                                defaults.synchronize()
//                            }
//                            if(defaults.objectForKey("type") as! Int==1){
//                                tempMinMax = String(record.objectForKey("temperatureMin") as! Int)+"/"+String(record.objectForKey("temperatureMax") as! Int)
//                                //                            let texto:NSMutableAttributedString = NSMutableAttributedString(string:tempMinMax)
//                                //                            texto.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: 35)!, range: NSRange(location: 0,length: count(tempMinMax)))
//                                //                            temperatureLabel.attributedText = texto
//                            }
//                            else{
//                                
//                                tempMinMax = String(farenheittoCelsius(record.objectForKey("temperatureMin") as! Int))+"/"+String(farenheittoCelsius(record.objectForKey("temperatureMax") as! Int))
//                                //                            let texto:NSMutableAttributedString = NSMutableAttributedString(string:tempMinMax)
//                                //                            texto.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: 35)!, range: NSRange(location: 0,length: count(tempMinMax)))
//                                //                            temperatureLabel.attributedText = texto
//                            }
//                            
//                            var summary = ""
//                            summary = record.objectForKey("summary") as! String
//                            let summaryx = summary.componentsSeparatedByString(" ")
//                            let wind = String(record.objectForKey("windSpeed") as! Int)
//                            dateFormatter.dateFormat = "EEEE"
//                            let titlex = dateFormatter.stringFromDate(date)
//                            let endIndex = advance(titlex.startIndex, 3)
//                            var text = titlex.substringToIndex(endIndex)//dateFormatter.stringFromDate(date)
//                            text += "   "
//                            text += summaryx[0]
//                            if(summaryx.count>0){
//                                text += " "
//                                text += summaryx[1]
//                            }
//                            text += " "
//                            text += tempMinMax
//                            text += " "
//                            text += wind
//                            text += " mph"
//                            let length = count(titlex.substringToIndex(endIndex))
//                            let texto:NSMutableAttributedString = NSMutableAttributedString(string:text)
//                            texto.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: 12.0)!, range: NSRange(location: 0,length: 3))
//                            texto.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: 15.0)!, range: NSRange(location: 4,length: count(text)-4))
//                            labels[i].attributedText = texto//dateFormatter.stringFromDate(date)+"   "+summaryx[0]+"   "+tempMinMax+"   "+wind
//                            labels[i].textAlignment = .Left
//                        }
//                        
//                    }
//                    i++
//                }
//            }
//            
//        }
//    }
    
//    var labels = [UILabel]()
    var dayLabel1 = UILabel()
    var dayLabel2 = UILabel()
    var dayLabel3 = UILabel()
    var dayLabel4 = UILabel()
    var dayLabel5 = UILabel()
    var dayLabel6 = UILabel()
    let viewx = UIScrollView(frame: CGRectMake(0, 0, 0, 5))
//    func configView(){
//        labels.removeAll(keepCapacity: false)
//        viewx.backgroundColor = UIColor(hue:0.58, saturation:0.92, brightness:0.84, alpha:1)
//        dayLabel1.textColor = UIColor.whiteColor()
//        labels.append(dayLabel1)
//        labels.append(dayLabel2)
//        labels.append(dayLabel3)
//        labels.append(dayLabel4)
//        labels.append(dayLabel5)
//        labels.append(dayLabel6)
//        for record in labels{
//            record.textColor = UIColor.whiteColor()
//            record.font = UIFont(name: "HelveticaNeue-Light", size: 20)
//        }
//        viewx.addSubview(dayLabel1)
//        viewx.addSubview(dayLabel2)
//        viewx.addSubview(dayLabel3)
//        viewx.addSubview(dayLabel4)
//        viewx.addSubview(dayLabel5)
//        viewx.addSubview(dayLabel6)
//        
//    }
    
    
    var labels = [UILabel]()
    var labels1 = [UILabel]()
    var labels2 = [UILabel]()
    var labels3 = [UILabel]()
    func configView(){
        viewx.removeFromSuperview()
        labels.removeAll(keepCapacity: false)
//        viewx.backgroundColor = UIColor(hue:0.58, saturation:0.92, brightness:0.84, alpha:1)
        dayLabel1.textColor = UIColor.whiteColor()
        labels.append(dayLabel1)
        labels.append(dayLabel2)
        labels.append(dayLabel3)
        labels.append(dayLabel4)
        labels.append(dayLabel5)
        labels.append(dayLabel6)
        
        labels1.append(dayLabel11)
        labels1.append(dayLabel21)
        labels1.append(dayLabel31)
        labels1.append(dayLabel41)
        labels1.append(dayLabel51)
        labels1.append(dayLabel61)
        
        labels2.append(dayLabel12)
        labels2.append(dayLabel22)
        labels2.append(dayLabel32)
        labels2.append(dayLabel42)
        labels2.append(dayLabel52)
        labels2.append(dayLabel62)
        
        labels3.append(dayLabel13)
        labels3.append(dayLabel23)
        labels3.append(dayLabel33)
        labels3.append(dayLabel43)
        labels3.append(dayLabel53)
        labels3.append(dayLabel63)
        let size:CGFloat = 16.0
        let font = UIFont(name: "Avenir-Book", size: size)
        for record in labels{
            record.textColor = UIColor(hue:0.17, saturation:0.01, brightness:0.63, alpha:1)
            record.font = font
                        record.removeFromSuperview()
        }
        
        for record in labels1{
            record.textColor = UIColor.whiteColor()
            record.font = font
                        record.removeFromSuperview()
        }
        
        for record in labels2{
            record.textColor = UIColor.whiteColor()
            record.font = font
                        record.removeFromSuperview()
        }
        
        for record in labels3{
            record.textColor = UIColor.whiteColor()
            record.font = font
                        record.removeFromSuperview()
        }
        viewx.addSubview(dayLabel1)
        viewx.addSubview(dayLabel2)
        viewx.addSubview(dayLabel3)
        viewx.addSubview(dayLabel4)
        viewx.addSubview(dayLabel5)
        viewx.addSubview(dayLabel6)
        
        viewx.addSubview(dayLabel11)
        viewx.addSubview(dayLabel21)
        viewx.addSubview(dayLabel31)
        viewx.addSubview(dayLabel41)
        viewx.addSubview(dayLabel51)
        viewx.addSubview(dayLabel61)
        
        viewx.addSubview(dayLabel12)
        viewx.addSubview(dayLabel22)
        viewx.addSubview(dayLabel32)
        viewx.addSubview(dayLabel42)
        viewx.addSubview(dayLabel52)
        viewx.addSubview(dayLabel62)
        
        viewx.addSubview(dayLabel13)
        viewx.addSubview(dayLabel23)
        viewx.addSubview(dayLabel33)
        viewx.addSubview(dayLabel43)
        viewx.addSubview(dayLabel53)
        viewx.addSubview(dayLabel63)
        
        
       
        gesture.addTarget(self, action: #selector(TodayViewController.nextPage))
        self.newLabel.addGestureRecognizer(gesture)
        newLabel.userInteractionEnabled = true
       
        viewx.hidden = true
        
    }
    
//    
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
//        return true
//    }
//    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
    
    var dayLabel11 = UILabel()
    var dayLabel21 = UILabel()
    var dayLabel31 = UILabel()
    var dayLabel41 = UILabel()
    var dayLabel51 = UILabel()
    var dayLabel61 = UILabel()
    
    var dayLabel12 = UILabel()
    var dayLabel22 = UILabel()
    var dayLabel32 = UILabel()
    var dayLabel42 = UILabel()
    var dayLabel52 = UILabel()
    var dayLabel62 = UILabel()
    
    var dayLabel13 = UILabel()
    var dayLabel23 = UILabel()
    var dayLabel33 = UILabel()
    var dayLabel43 = UILabel()
    var dayLabel53 = UILabel()
    var dayLabel63 = UILabel()
    
    
    func nextDay(){
        if(self.defaults.objectForKey("weatherDictionary")==nil){
            
        }
        else{
           
            let weatherDictionary = self.defaults.objectForKey("weatherDictionary") as! NSDictionary
//            let data = WeatherData(weatherDictionary: weatherDictionary)
            let weatherdaily = weatherDictionary["daily"] as! NSDictionary
//            var tMin = 0
            var i = 0
            if let temp = weatherdaily["data"] as? NSArray{
                
                for record in temp{
                    
                    if (i<labels.count){
                        print("next")
                        let temperatureMinTime = record.objectForKey("time") as! NSNumber
                        let timeInterval = NSTimeInterval(temperatureMinTime)
                        let date = NSDate(timeIntervalSince1970: timeInterval)
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
                        dateFormatter.dateStyle = .ShortStyle
//                        let nextDay = NSDate().dateByAddingTimeInterval(60*60*24*Double(i))
//                        if(dateFormatter.stringFromDate(date)==dateFormatter.stringFromDate(nextDay)){

                            //                        summaryLabel.text = record.objectForKey("summary") as? String
                            //                        windspeedLabel.text =  String(record.objectForKey("windSpeed") as! Int)
                            var tempMinMax = ""
                            
                            if(defaults.objectForKey("type")==nil){
                                defaults.setObject(1 as Int?, forKey:"type")
                                defaults.synchronize()
                            }
                            if(defaults.objectForKey("type") as! Int==1){
                                tempMinMax = String(record.objectForKey("temperatureMin") as! Int)+"/"+String(record.objectForKey("temperatureMax") as! Int)
                                //                            let texto:NSMutableAttributedString = NSMutableAttributedString(string:tempMinMax)
                                //                            texto.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: 35)!, range: NSRange(location: 0,length: count(tempMinMax)))
                                //                            temperatureLabel.attributedText = texto
                            }
                            else{
                                
                                tempMinMax = String(farenheittoCelsius(record.objectForKey("temperatureMin") as! Int))+"/"+String(farenheittoCelsius(record.objectForKey("temperatureMax") as! Int))
                                //                            let texto:NSMutableAttributedString = NSMutableAttributedString(string:tempMinMax)
                                //                            texto.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: 35)!, range: NSRange(location: 0,length: count(tempMinMax)))
                                //                            temperatureLabel.attributedText = texto
                            }
                            
                            var summary = ""
                            summary = record.objectForKey("summary") as! String
                            let summaryx = summary.componentsSeparatedByString(" ")
                            let wind = String(record.objectForKey("windSpeed") as! Int)
                            dateFormatter.dateFormat = "EEEE"
                            let titlex = dateFormatter.stringFromDate(date)
                            let endIndex = titlex.startIndex.advancedBy(3)
                            var text = titlex.substringToIndex(endIndex)//dateFormatter.stringFromDate(date)
                            text += "   "
                            text += summaryx[0]
                            if(summaryx.count>0){
                                text += " "
                                text += summaryx[1]
                            }
                            text += " "
                            text += tempMinMax
                            text += " "
                            text += wind
                            text += " mph"
//                            let length = titlex.substringToIndex(endIndex).characters.count
                            let texto:NSMutableAttributedString = NSMutableAttributedString(string:text)
                            texto.addAttribute(NSFontAttributeName, value: UIFont(name: "Avenir-Book", size: 14.0)!, range: NSRange(location: 0,length: 3))
                            texto.addAttribute(NSFontAttributeName, value: UIFont(name: "Avenir-Book", size: 20.0)!, range: NSRange(location: 4,length: text.characters.count-4))
                            //                        labels[i].attributedText = texto
                            labels[i].text = titlex.substringToIndex(endIndex)
                            var lengthx = summaryx[1].characters.count
                            if(lengthx>7){
                            lengthx = 7
                            }
                            labels1[i].text = summaryx[0]+" "+summaryx[1].substringToIndex(summaryx[1].startIndex.advancedBy(lengthx))
                            labels2[i].text = tempMinMax
                            labels3[i].text = wind+" mph"

                            labels[i].textAlignment = .Left
//                        }
                        
                    }
                    i += 1
                }
            }
            
        }
    }
}
