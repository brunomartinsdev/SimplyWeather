//
//  StartViewController.swift
//  Weather
//
//  Created by Bruno Lima Martins on 6/5/15.
//  Copyright (c) 2015 Bruno Lima. All rights reserved.
//

import Foundation
import UIKit

class StartViewController: UIViewController{
    var pageControl = UIPageControl()
    let scrollView = UIScrollView()    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let h:CGFloat = 34
        let w:CGFloat = h
        
        pageControl.backgroundColor = UIColor(hue:0.58, saturation:0.92, brightness:0.84, alpha:1)
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        scrollView.addSubview(pageControl)
        

        let optionsButton = UIBarButtonItem(title: "Options", style: .Plain, target: self, action: Selector("optionsButtonPressed:"))
        

        let refreshButton = UIBarButtonItem(title: "Refresh", style: .Plain, target: self, action: Selector("refreshNow:"))
        
        let locationButton = UIBarButtonItem(title: "Locations", style: .Plain, target: self, action: Selector("locationsButtonPressed"))
       
        if let font = UIFont(name: "Avenir-Book", size: 18) {
            locationButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
            optionsButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
            optionsButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        self.navigationItem.rightBarButtonItems = [refreshButton,optionsButton]
        self.navigationItem.leftBarButtonItem = locationButton
        view.backgroundColor = UIColor(hue:0.58, saturation:0.92, brightness:0.84, alpha:1)
        gesture.direction = UISwipeGestureRecognizerDirection.Left
        gesture.addTarget(self, action: "leftGesture")
        scrollView.addGestureRecognizer(gesture)
        view.addSubview(scrollView)

    }
    
    let gesture = UISwipeGestureRecognizer()
    var page = 0
    
    func refreshNow(sender:UIButton){

        NSNotificationCenter.defaultCenter().postNotificationName("refreshWeather", object: nil)
    }
    
       
    func leftGesture(){
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

    
    override func viewDidLayoutSubviews() {
        let navHeight:CGFloat = 0
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