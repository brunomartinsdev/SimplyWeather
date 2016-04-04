//
//  LocationViewController.swift
//  Weather CF
//
//  Created by Bruno Lima Martins on 5/6/15.
//  Copyright (c) 2015 Bruno Lima. All rights reserved.
//


import UIKit
import CoreLocation

class LocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let tableView = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
    
    //    let defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.bdevapps.WeatherCF")!
    let defaults = NSUserDefaults.standardUserDefaults()
    var savedArray = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(LocationViewController.doneButtonPressed(_:)))
        self.navigationController?.navigationBar.barTintColor = UIColor(hue:0.58, saturation:0.92, brightness:0.84, alpha:1)
        self.navigationController?.navigationBar.translucent = false
        let plusButton = UIBarButtonItem(title: "+", style: .Plain, target: self, action: #selector(LocationViewController.seguex))
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "LogCell")
        tableView.dataSource = self
        tableView.delegate = self
        self.navigationItem.leftBarButtonItem = doneButton
        self.navigationItem.rightBarButtonItem = plusButton
        self.navigationItem.hidesBackButton = true
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView?.hidden = true
        self.navigationController?.topViewController!.title = "Locations"
        self.tableView.reloadData()
        view.addSubview(tableView)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        reloadTable()
    }
    
    func doneButtonPressed(sender:UIBarButtonItem){
        performSegueWithIdentifier("back", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "back"){
            let animationDuration = 0.35
            
            
            view.transform = CGAffineTransformScale(view.transform, 0.001, 0.001)
            
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
                let v = self.navigationController?.view
                UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromRight, forView: v!
                    , cache: false)
            })
            
        }
        else{
            animVIew()}
    }
    
    func animVIew(){
        
        let animationDuration = 0.35
        
        
        view.transform = CGAffineTransformScale(view.transform, 0.001, 0.001)
        
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            let v = self.navigationController?.view
            UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromLeft, forView: v!
                , cache: false)
        })
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func seguex(){
        animVIew()
        performSegueWithIdentifier("add", sender: self)
    }
    
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return false
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.savedArray.count
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        var dict = Dictionary<Int, [String:String]>()
        dict = savedArray as! Dictionary<Int, [String : String]>
        print(dict[indexPath.row]?.description)
        if(dict[indexPath.row]?.description=="[latLong: , name: My Location]"){
            return false
        }else{
            return true}
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("LogCell")
        cell!.textLabel?.textAlignment = .Center
        var dict = Dictionary<Int, [String:String]>()
        dict = savedArray as! Dictionary<Int, [String : String]>
        let text = dict[indexPath.row]?.description
        let cellText = text?.componentsSeparatedByString("name\":")
        cell!.textLabel?.text = cellText?.last!.stringByReplacingOccurrencesOfString("]", withString: "").stringByReplacingOccurrencesOfString("\"", withString: "")
        cell!.textLabel?.textColor = UIColor.blackColor()
        cell!.textLabel?.font = UIFont(name: "Avenir-Book", size: 20)
        tableView.rowHeight = 35
        let locationData = defaults.objectForKey("locationData") as! [String:String]
        if(dict[indexPath.row]!==locationData){
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell!.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell!
        
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var dict = Dictionary<Int, [String:String]>()
        dict = savedArray as! Dictionary<Int, [String : String]>
        defaults.setObject(dict[indexPath.row], forKey:"locationData")
        defaults.synchronize()
        reloadTable()
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(editingStyle == .Delete ) {
            
            let data = defaults.objectForKey("locationList") as! NSData
            let savedArray = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSDictionary
            var dict = Dictionary<Int, [String : String]>()
            dict = savedArray as! Dictionary<Int, [String : String]>
            var dict2 = Dictionary<Int, [String : String]>()
            dict2 = dict
            var x = 0
            for _ in dict{
                if(x>=indexPath.row){
                    dict[x] = dict2[x+1]
                }
                x += 1
            }
            
            let dataSave = NSKeyedArchiver.archivedDataWithRootObject(dict)
            defaults.setObject(dataSave, forKey:"locationList")
            defaults.synchronize()
            reloadTable()
        }
        
        
    }
    func reloadTable(){
        if(defaults.objectForKey("locationList")==nil){
            let locations  = ["name": "My Location", "latLong": ""]
            var dict = Dictionary<Int, [String:String]>()
            dict[0] = locations//.first
            let dataSave = NSKeyedArchiver.archivedDataWithRootObject(dict)
            defaults.setObject(dataSave, forKey:"locationList")
            defaults.synchronize()
        }
        let data = defaults.objectForKey("locationList") as! NSData
        savedArray = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSDictionary
        tableView.reloadData()
        
    }
    
} 
