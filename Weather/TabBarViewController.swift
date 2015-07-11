//
//  TabBarViewController.swift
//  Weather
//
//  Created by Bruno Lima Martins on 5/5/15.
//  Copyright (c) 2015 Bruno Lima. All rights reserved.
//

import UIKit
import CoreLocation

class TabBarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchResultsUpdating {
    let tableView = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
    let defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.bdevapps.WeatherCF")!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doneButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: Selector("doneButtonPressed:"))
        self.navigationItem.leftBarButtonItem = doneButton
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "LogCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView?.hidden = true
        self.tableView.backgroundView = nil
        self.resultSearchController = ({
            
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.barStyle = UIBarStyle.Black
            controller.searchBar.barTintColor = UIColor.whiteColor()
            controller.searchBar.backgroundColor = UIColor.clearColor()
            controller.navigationController?.setNavigationBarHidden(false, animated: true)
            self.tableView.tableHeaderView = controller.searchBar
            
            
            return controller
            
        })()
        resultSearchController.hidesNavigationBarDuringPresentation = false
        view.addSubview(tableView)
        fetchLog()
        
    }
    
    func doneButtonPressed(sender:UIBarButtonItem){
        animView()
        performSegueWithIdentifier("back", sender: self)
    }
    
    func animView(){
        
        let animationDuration = 0.35
        view.transform = CGAffineTransformScale(view.transform, 0.001, 0.001)
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            let v = self.navigationController?.view
            UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromRight, forView: v!
                , cache: false)
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return false
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.resultSearchController.active) {
            return self.filteredTableData.count
        }
        else{
            
            return self.diction.count
            
        }
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        filteredTableData.removeAll(keepCapacity: false)
        filteredTableData1.removeAll(keepCapacity: false)
        var array1 = ["",""]
        var array2 = ["",""]
        array1.removeAll(keepCapacity: false)
        array2.removeAll(keepCapacity: false)
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchController.searchBar.text, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                if let loc = placemark.locality{
                    array2.append(placemark.locality+" "+placemark.administrativeArea)
                    array1.append(String(stringInterpolationSegment: placemark.location.coordinate.latitude)+","+String(stringInterpolationSegment: placemark.location.coordinate.longitude))
                }}
            self.filteredTableData = array2 as [String]
            self.filteredTableData1 = array1 as [String]
            self.tableView.reloadData()
        })
        self.tableView.reloadData()
    }
    
    var filteredTableData = [String]()
    var filteredTableData1 = [String]()
    var resultSearchController = UISearchController()
    
    func fetchLog() {
        diction.removeAll(keepCapacity: false)
        tableView.reloadData()
        
    }
    
    var diction = ["","","",""]
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("LogCell") as! UITableViewCell
        cell.textLabel?.textAlignment = .Center
        if (self.resultSearchController.active) {
            cell.textLabel?.text = filteredTableData[indexPath.row]
            
        }
        else{
            cell.textLabel?.text =  self.diction[indexPath.row]}
        
        
        cell.textLabel?.textColor = UIColor.blackColor()
        cell.textLabel?.font = UIFont(name: "Avenir-Book", size: 20)
        
        tableView.rowHeight = 35
        
        return cell
        
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        
    }
    
 
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog(filteredTableData1[indexPath.row]+" "+filteredTableData[indexPath.row])
        let data = defaults.objectForKey("locationList") as! NSData
        let savedArray = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSDictionary
        let i = savedArray.count
        var dict = Dictionary<Int, [String : String]>()
        dict = savedArray as! Dictionary<Int, [String : String]>
        let locations  = ["name": filteredTableData[indexPath.row], "latLong": filteredTableData1[indexPath.row]]
        dict[i] = locations
        let dataSave = NSKeyedArchiver.archivedDataWithRootObject(dict)
        defaults.setObject(dataSave, forKey:"locationList")
        defaults.synchronize()
        defaults.setObject(locations, forKey:"locationData")
        defaults.synchronize()
        resultSearchController.active = false
        animView()
        performSegueWithIdentifier("back", sender: self)
    }
    
}