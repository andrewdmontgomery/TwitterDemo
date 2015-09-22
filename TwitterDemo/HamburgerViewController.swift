//
//  HambergerViewController.swift
//  TwitterDemo
//
//  Created by Andrew Montgomery on 9/20/15.
//  Copyright © 2015 Andrew Montgomery. All rights reserved.
//

import UIKit

let kContentViewPeak = CGFloat(40)
let kUserDidPressMenuBarButton = "userDidPressMenuBarButton"

class HamburgerViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    private var originalLeftMargin: CGFloat!
    
    var menuViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            
            if oldContentViewController != nil {
                oldContentViewController.willMoveToParentViewController(nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMoveToParentViewController(nil)
            }
            
            menuView.addSubview(menuViewController.view)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            
            if oldContentViewController != nil {
                oldContentViewController.willMoveToParentViewController(nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMoveToParentViewController(nil)
            }
            
            contentViewController.willMoveToParentViewController(self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMoveToParentViewController(self)
            
            UIView.animateWithDuration(0.3) { () -> Void in
                self.leftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidPressMenuBarButton", name: kUserDidPressMenuBarButton, object: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            originalLeftMargin = leftMarginConstraint.constant
        } else if sender.state == UIGestureRecognizerState.Changed {
            leftMarginConstraint.constant = originalLeftMargin + translation.x
        } else if sender.state == UIGestureRecognizerState.Ended {
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                if velocity.x > 0 {
                    self.leftMarginConstraint.constant = self.view.frame.size.width - kContentViewPeak
                } else {
                    self.leftMarginConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func userDidPressMenuBarButton() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            let currentLeftMarginConstrantConstant = self.leftMarginConstraint.constant
            if currentLeftMarginConstrantConstant == 0 {
                self.leftMarginConstraint.constant = self.view.frame.size.width - kContentViewPeak
            } else {
                self.leftMarginConstraint.constant = 0
            }
            self.view.layoutIfNeeded()
        })

        
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
