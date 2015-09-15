//
//  NewTweetViewController.swift
//  TwitterDemo
//
//  Created by Andrew Montgomery on 9/14/15.
//  Copyright (c) 2015 Andrew Montgomery. All rights reserved.
//

import UIKit

@objc protocol NewTweetViewControllerDelegate {
    optional func newTweetViewController(newTweetViewController: NewTweetViewController, didPostStatusWithParams: [String:AnyObject])
    optional func newTweetViewControllerDidCancelStatus(newTweetViewController: NewTweetViewController)
}

class NewTweetViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    
    weak var delegate: NewTweetViewControllerDelegate?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = user?.name
        screenNameLabel.text = user?.screenname
        if let profileImageURLString = user?.profileImageUrl {
            let profileImageURL = NSURL(string: profileImageURLString)
            profileImageView.setImageWithURL(profileImageURL)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onSendTweet(sender: AnyObject) {
        if count(tweetTextView.text) > 0 {
            var statusParams = ["status" : tweetTextView.text]
            TwitterClient.sharedInstance.postStatusWithParams(statusParams, completion: { (tweet, error) -> () in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }

    @IBAction func onCancelTweet(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
