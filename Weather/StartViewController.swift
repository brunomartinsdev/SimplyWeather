//
//  StartViewController.swift
//  Weather CF
//
//  Created by Bruno Lima Martins on 6/5/15.
//  Copyright (c) 2015 Bruno Lima. All rights reserved.
//

import Foundation
import UIKit

class StartViewController: UIViewController{
    var pageControl = UIPageControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let h:CGFloat = 34
        let w:CGFloat = h
        
        pageControl.backgroundColor = UIColor(hue:0.58, saturation:0.92, brightness:0.84, alpha:1)
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        scrollView.addSubview(pageControl)
        
        let optionsButton = UIButton(type:UIButtonType.Custom)
        optionsButton.frame = CGRectMake(0, 0, w, h)
        optionsButton.layer.borderWidth = 0.0
        optionsButton.layer.borderColor = UIColor.whiteColor().CGColor
        optionsButton.layer.masksToBounds = false
        optionsButton.layer.cornerRadius = w/2
        optionsButton.setImage(UIImage(named:"options")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
        optionsButton.tintColor = UIColor.whiteColor()
        optionsButton.addTarget(self, action: #selector(StartViewController.optionsButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let buttonRight =  UIBarButtonItem(customView: optionsButton)
        
        
        let refreshButton = UIButton(type:UIButtonType.Custom)
        refreshButton.frame = CGRectMake(0, 0, w, h)
        refreshButton.layer.borderWidth = 0.0
        refreshButton.layer.borderColor = UIColor.whiteColor().CGColor
        refreshButton.layer.masksToBounds = false
        refreshButton.layer.cornerRadius = w/2
        refreshButton.tintColor = UIColor.whiteColor()
        refreshButton.setImage(UIImage(named:"refresh")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
        refreshButton.addTarget(self, action: #selector(StartViewController.refreshNow(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let refresh = UIBarButtonItem(customView: refreshButton)
        
        
        let locationButton = UIButton(type:UIButtonType.Custom)
        locationButton.frame = CGRectMake(0, 0, w, h)
        locationButton.layer.borderWidth = 1.0
        locationButton.layer.borderColor = UIColor.whiteColor().CGColor
        locationButton.layer.masksToBounds = false
        locationButton.layer.cornerRadius = w/2
        locationButton.tintColor = UIColor.whiteColor()
        locationButton.setImage(UIImage(named:"Locations")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
        locationButton.addTarget(self, action: #selector(StartViewController.locationsButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
        
        let buttonLeft = UIBarButtonItem()
        buttonLeft.title = "Locations"
        buttonLeft.target = self
        buttonLeft.action = #selector(StartViewController.locationsButtonPressed)
        
        if let font = UIFont(name: "Avenir-Book", size: 18) {
            buttonLeft.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        self.navigationItem.rightBarButtonItems = [buttonRight,refresh]
        self.navigationItem.leftBarButtonItem = buttonLeft
        view.backgroundColor = UIColor(hue:0.58, saturation:0.92, brightness:0.84, alpha:1)
        gesture.direction = UISwipeGestureRecognizerDirection.Left
        gesture.addTarget(self, action: #selector(StartViewController.gestureActived))
        scrollView.addGestureRecognizer(gesture)
        view.addSubview(scrollView)
        delay(1.0) {
            self.refreshNow(refreshButton)
        }
    }
    
    let gesture = UISwipeGestureRecognizer()
    var page = 0
    
    func refreshNow(sender:UIButton){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(1 as Int?, forKey:"refresh")
        defaults.synchronize()
        rotate(sender)
        NSNotificationCenter.defaultCenter().postNotificationName("updateFetchLogNotificationIdentifier", object: nil)
    }
    
    func rotate(sender:UIButton){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        sender.transform = CGAffineTransformMakeRotation(0)
        let animationDuration = 1.0
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            
            sender.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        })
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            
            sender.transform = CGAffineTransformMakeRotation(CGFloat(0))
            }
            ,
            completion: {finished in  if(defaults.objectForKey("refresh") as! Int==1){
                self.rotate(sender)
                }
                
                
            }
        )
        
        
    }
    
    func delay(delay:Double, closure:()->()) {
        //        from:http://stackoverflow.com/questions/24034544/dispatch-after-gcd-in-swift/24318861#24318861
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    func gestureActived(){
        if(page==0){
            
            gesture.direction = UISwipeGestureRecognizerDirection.Right
            page = 1
            let firstPage = storyboard!.instantiateViewControllerWithIdentifier("OtherDaysViewController") as! OtherDaysViewController
            self.addChildViewController(firstPage)
            scrollView.addSubview(firstPage.view)
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad{
                firstPage.view.frame = CGRect(x: 0, y: 310, width: firstPage.view.bounds.width, height: firstPage.view.bounds.height)
            }else{
                firstPage.view.frame = CGRect(x: 0, y: 240, width: firstPage.view.bounds.width, height: firstPage.view.bounds.height)
                
            }
            firstPage.didMoveToParentViewController(self)
        }
        else{
            gesture.direction = UISwipeGestureRecognizerDirection.Left
            page = 0
            let secondPage = storyboard!.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
            self.addChildViewController(secondPage)
            scrollView.addSubview(secondPage.view)
            secondPage.view.frame = CGRect(x: 0, y: 0, width: secondPage.view.bounds.width, height: secondPage.view.bounds.height)
            secondPage.didMoveToParentViewController(self)
            
            
            
        }
        pageControl.currentPage = page
        scrollView.bringSubviewToFront(pageControl)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    var i  = 0
    
    
    var scrollView = UIScrollView()
    override func viewDidLayoutSubviews() {
        
        scrollView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad{
            pageControl.frame = CGRectMake(0, 300-0, view.bounds.size.width, 5)
        }else{
            pageControl.frame = CGRectMake(0, 210, view.bounds.size.width, 5)}
    }
    
    
    func optionsButtonPressed(sender:UIBarButtonItem){
        
        performSegueWithIdentifier("options", sender: self)
        
    }
    override func viewDidAppear(animated: Bool) {
        let firstPage = storyboard!.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        self.addChildViewController(firstPage)
        scrollView.addSubview(firstPage.view)
        firstPage.view.frame = CGRect(x: 0, y: 0, width: firstPage.view.bounds.width, height: firstPage.view.bounds.height)
        firstPage.didMoveToParentViewController(self)
        scrollView.bringSubviewToFront(pageControl)
        
    }
    
    
    func locationsButtonPressed(){
        performSegueWithIdentifier("locations", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "locations"){
            let animationDuration = 0.35
            view.transform = CGAffineTransformScale(view.transform, 0.001, 0.001)
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
                let v = self.navigationController?.view
                UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromLeft, forView: v!
                    , cache: false)
            })
            
        }
        else{
            animView()
        }
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
    
    
}