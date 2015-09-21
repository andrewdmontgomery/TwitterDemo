//
//  ViewController.swift
//  TwitterDemo
//
//  Created by Andrew Montgomery on 9/10/15.
//  Copyright (c) 2015 Andrew Montgomery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
                
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "hamburgerSegue" {
            let hamburgerViewController = segue.destinationViewController as! HamburgerViewController
            
            //let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let menuViewController = AppDelegate.storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController

            menuViewController.hamburgerViewController = hamburgerViewController
            hamburgerViewController.menuViewController = menuViewController
        }
    }

    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user:User?, error: NSError?) in
            if user != nil {
                // perform segue
                self.performSegueWithIdentifier("hamburgerSegue", sender: self)
            } else {
                // handle login error
            }
        }
    }
}

