//
//  OtherDaysViewController.swift
//  Weather
//
//  Created by Bruno Lima Martins on 6/5/15.
//  Copyright (c) 2015 Bruno Lima. All rights reserved.
//

import Foundation
import WeatherDataKit
class OtherDaysViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(viewx)
        configView()
        nextDay()
        viewx.contentSize = CGSizeMake(0, 500)
        viewx.contentOffset = CGPointMake(0,0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewDidAppear(animated: Bool) {
        nextDay()
    }
    
    override func viewDidLayoutSubviews() {
        viewx.frame = CGRectMake(0,0, UIScreen.mainScreen().bounds.width, 350)
        var i = 1
        var origin:CGFloat = view.bounds.width/10
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad{
            origin = viewx.frame.width/3
            
        }
        
        for record in labels{
            record.frame = CGRectMake(origin,CGFloat(CGFloat(i*50)),150, 30)
            i++
        }
        i = 1
        for record in labels1{
            record.frame = CGRectMake(50+origin,CGFloat(CGFloat(i*50)),viewx.frame.width-viewx.frame.width/5, 30)
            i++
        }
        i = 1
        for record in labels2{
            record.frame = CGRectMake(180+origin,CGFloat(CGFloat(i*50)),viewx.frame.width-viewx.frame.width/5, 30)
            i++
        }
        i = 1
        
        for record in labels3{
            record.frame = CGRectMake(230+origin,CGFloat(CGFloat(i*50)),viewx.frame.width-viewx.frame.width/5, 30)
            i++
        }
    }
    
    var dayLabel1 = UILabel()
    var dayLabel2 = UILabel()
    var dayLabel3 = UILabel()
    var dayLabel4 = UILabel()
    var dayLabel5 = UILabel()
    var dayLabel6 = UILabel()
    
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
    
    var labels = [UILabel]()
    var labels1 = [UILabel]()
    var labels2 = [UILabel]()
    var labels3 = [UILabel]()
    let viewx = UIScrollView(frame: CGRectMake(0, 0, 0, 5))
    func configView(){
        labels.removeAll(keepCapacity: false)
        viewx.backgroundColor = UIColor(hue:0.58, saturation:0.92, brightness:0.84, alpha:1)
        view.backgroundColor = UIColor(hue:0.58, saturation:0.92, brightness:0.84, alpha:1)
        
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
        for record in labels{
            record.textColor = UIColor.whiteColor()
            record.font = UIFont(name: "HelveticaNeue-Light", size: size)
            viewx.addSubview(record)
        }
        
        for record in labels1{
            record.textColor = UIColor.whiteColor()
            record.font = UIFont(name: "HelveticaNeue-Light", size: size)
            viewx.addSubview(record)
        }
        
        for record in labels2{
            record.textColor = UIColor.whiteColor()
            record.font = UIFont(name: "HelveticaNeue-Light", size: size)
            viewx.addSubview(record)
        }
        
        for record in labels3{
            record.textColor = UIColor.whiteColor()
            record.font = UIFont(name: "HelveticaNeue-Light", size: size)
            viewx.addSubview(record)
        }
    }
    
    
    func farenheittoCelsius(temperature:NSNumber)->Int{
        
        let temperature = (Double(temperature)-32)/1.8
        return Int(temperature)
    }
    
    
    let defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.bdevapps.WeatherCF")!
    func nextDay(){
        if(self.defaults.objectForKey("weatherDictionary")==nil){
            
        }
        else{
            let weatherDictionary = self.defaults.objectForKey("weatherDictionary") as! NSDictionary
            let data = WeatherData(weatherDictionary: weatherDictionary)
            let weatherdaily = weatherDictionary["daily"] as! NSDictionary
            var tMin = 0
            var i = 0
            if let temp = weatherdaily["data"] as? NSArray{
                
                for record in temp{
                    if (i<labels.count){
                        let temperatureMinTime = record.objectForKey("time") as! NSNumber
                        let timeInterval = NSTimeInterval(temperatureMinTime)
                        let date = NSDate(timeIntervalSince1970: timeInterval)
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
                        dateFormatter.dateStyle = .ShortStyle
                        let nextDay = NSDate().dateByAddingTimeInterval(60*60*24*Double(i))
                        var tempMinMax = ""
                        if(defaults.objectForKey("type")==nil){
                            defaults.setObject(1 as Int?, forKey:"type")
                            defaults.synchronize()
                        }
                        if(defaults.objectForKey("type") as! Int==1){
                            tempMinMax = String(record.objectForKey("temperatureMin") as! Int)+"/"+String(record.objectForKey("temperatureMax") as! Int)
                        }
                        else{
                            
                            tempMinMax = String(farenheittoCelsius(record.objectForKey("temperatureMin") as! Int))+"/"+String(farenheittoCelsius(record.objectForKey("temperatureMax") as! Int))
                        }
                        
                        var summary = ""
                        summary = record.objectForKey("summary") as! String
                        let summaryx = summary.componentsSeparatedByString(" ")
                        let wind = String(record.objectForKey("windSpeed") as! Int)
                        dateFormatter.dateFormat = "EEEE"
                        let titlex = dateFormatter.stringFromDate(date)
                        let endIndex = advance(titlex.startIndex, 3)
                        var text = titlex.substringToIndex(endIndex)
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
                        let length = count(titlex.substringToIndex(endIndex))
                        let texto:NSMutableAttributedString = NSMutableAttributedString(string:text)
                        texto.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: 14.0)!, range: NSRange(location: 0,length: 3))
                        texto.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: 20.0)!, range: NSRange(location: 4,length: count(text)-4))
                        labels[i].text = titlex.substringToIndex(endIndex)
                        labels1[i].text = summaryx[0]+" "+summaryx[1]
                        labels2[i].text = tempMinMax
                        labels3[i].text = wind+" mph"
                        labels[i].textAlignment = .Left
                    }
                    i++
                }
            }
            
        }
    }
}
