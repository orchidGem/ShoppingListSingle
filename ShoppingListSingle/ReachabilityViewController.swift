//
//  ReachabilityViewController.swift
//  Grocery Pal
//
//  Created by Laura Evans on 5/20/16.
//  Copyright © 2016 Ivie. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func detectNetworkConnection() {
        if reachabilityStatus == kNOTREACHABLE {
            
            print("network not connected")
            
            let alertController = UIAlertController(title: "Network Error", message: "Unable to establish a network connection", preferredStyle: .Alert)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .Default, handler: { (UIAlertAction) in
                let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    dispatch_async(dispatch_get_main_queue(), {
                        UIApplication.sharedApplication().openURL(url)
                    })
                }
            })
            
            alertController.addAction(settingsAction)
            
            let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel) { (action) in }
            alertController.addAction(dismissAction)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.parentViewController?.presentViewController(alertController, animated: true, completion: nil)
            })
        }
    }
}