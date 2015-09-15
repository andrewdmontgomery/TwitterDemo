//
//  TweetsViewController.swift
//  TwitterDemo
//
//  Created by Andrew Montgomery on 9/13/15.
//  Copyright (c) 2015 Andrew Montgomery. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tweets: [Tweet]?
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchTweets", forControlEvents: UIControlEvents.ValueChanged)
        
        let dummyTableVC = UITableViewController()
        dummyTableVC.tableView = tableView
        dummyTableVC.refreshControl = refreshControl
        
        // Do any additional setup after loading the view.
        fetchTweets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchTweets()
    }
    
    func fetchTweets() {
        TwitterClient.sharedInstance.homeTimeLineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        })
    }

    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    @IBAction func postTweetStatus(segue: UIStoryboardSegue) {
        dismissViewControllerAnimated(true, completion: nil)
        let sourceViewController = segue.sourceViewController as! NewTweetViewController
        
    }
    
    @IBAction func cancelTweetStatus(segue: UIStoryboardSegue) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - NewTweetViewControllerDelegate
//    func newTweetViewController(newTweetViewController: NewTweetViewController, didPostStatusWithParams: [String:AnyObject]) {
//        if count(newTweetViewController.tweetTextView.text) > 0 {
//            var statusParams = ["status" : newTweetViewController.tweetTextView.text]
//            TwitterClient.sharedInstance.postStatusWithParams(didPostStatusWithParams, completion: { (tweet, error) -> () in
//                
//            })
//            newTweetViewController.dismissViewControllerAnimated(true, completion: nil)
//        }
//
//    }
//    
//    func newTweetViewControllerDidCancelStatus(newTweetViewController: NewTweetViewController) {
//        newTweetViewController.dismissViewControllerAnimated(true, completion: nil)
//    }
    
    // MARK: - UITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(tweetTableViewCellReuseIdentifier) as! TweetTableViewCell
        
        let tweet = tweets![indexPath.row]
        cell.tweet = tweet
        
        return cell
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let identifier = segue.identifier
        
        if identifier == "NewTweetSegueIdentifier" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let destinationViewController = navigationController.viewControllers[0] as! NewTweetViewController
            destinationViewController.user = User.currentUser
        }
    }
    

}
