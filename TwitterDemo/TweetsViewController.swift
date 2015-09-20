//
//  TweetsViewController.swift
//  TwitterDemo
//
//  Created by Andrew Montgomery on 9/13/15.
//  Copyright (c) 2015 Andrew Montgomery. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetDetailViewControllerDelegate, NewTweetViewControllerDelegate, TweetTableViewCellDelegate {

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
//    func newTweetViewController(newTweetViewController: NewTweetViewController, didPostStatusWithParams params: [String:AnyObject]) {
//        if count(newTweetViewController.tweetTextView.text) > 0 {
//            let status = params["status"] as? String
//            if status != nil {
//                TwitterClient.sharedInstance.postStatusWithParams(params, completion: { (tweet, error) -> () in
//                    if tweet != nil {
//                        self.tweets?.insert(tweet!, atIndex: 0)
//                        newTweetViewController.dismissViewControllerAnimated(true, completion: nil)
//                    }
//                })
//            }
//        }
//    }
    
    func newTweetViewController(newTweetViewController: NewTweetViewController, didPostRetweetWithParams params: [String : AnyObject]) {
        if newTweetViewController.tweetTextView.text.characters.count > 0 {
            let id = params["id"] as? Int
            if id != nil {
                TwitterClient.sharedInstance.postRetweetWithParams(params, completion: { (tweet, error) -> () in
                    self.tweets?.insert(tweet!, atIndex: 0)
                    newTweetViewController.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }
    }
    
//    func newTweetViewControllerDidCancelStatus(newTweetViewController: NewTweetViewController) {
//        newTweetViewController.dismissViewControllerAnimated(true, completion: nil)
//    }
    
    // MARK: - TweetDetailViewControllerDelegate
    func tweetDetailViewController(tweetDetailViewController: TweetDetailViewController, didToggleFavoriteForTweet tweet: Tweet?, withParams params: [String : AnyObject]) {
        var returnTweet: Tweet?
        if tweet != nil {
            returnTweet = tweet!
            
            if tweet!.favorited == false {
                TwitterClient.sharedInstance.postFavoriteWithParams(params, completion: { (tweet, error) -> () in
                    returnTweet!.favorited = true
                    tweetDetailViewController.tweet = returnTweet!
                    //tweetDetailViewController.updateFavoritedButtonImage()
                })
            } else if tweet?.favorited == true {
                TwitterClient.sharedInstance.destroyFavoriteWithParams(params, completion: { (tweet, error) -> () in
                    returnTweet!.favorited = false
                    tweetDetailViewController.tweet = returnTweet!
                    //tweetDetailViewController.updateFavoritedButtonImage()
                })
            }
        }
    }
    
    // MARK: - TweetTableViewCellDelegate
    func tweetTableViewCell(tweetTableViewCell: TweetTableViewCell, didToggleFavoriteForTweet tweet: Tweet?, withParams params: [String : Int]) {
        var returnTweet: Tweet?
        if tweet != nil {
            returnTweet = tweet!
            
            if tweet!.favorited == false {
                TwitterClient.sharedInstance.postFavoriteWithParams(params, completion: { (tweet, error) -> () in
                    returnTweet!.favorited = true
                    tweetTableViewCell.tweet = returnTweet!
                    //tweetDetailViewController.updateFavoritedButtonImage()
                })
            } else if tweet?.favorited == true {
                TwitterClient.sharedInstance.destroyFavoriteWithParams(params, completion: { (tweet, error) -> () in
                    returnTweet!.favorited = false
                    tweetTableViewCell.tweet = returnTweet!
                    //tweetDetailViewController.updateFavoritedButtonImage()
                })
            }
        }
    }
    
    func tweetTableViewCell(tweetTableViewCell: TweetTableViewCell, didTapReplytForTweet tweet: Tweet?) {
        performSegueWithIdentifier("ReplyTweetSegueIdentifier", sender: self)
    }
    
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
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //performSegueWithIdentifier("TweetDetailViewController", sender: self)
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
        
        if identifier == "TweetDetailViewController" {
            let cell = sender as! TweetTableViewCell
            let indexPath = tableView.indexPathForCell(cell)!
            let tweet = tweets![indexPath.row]
            
            let destinationViewController = segue.destinationViewController as! TweetDetailViewController
            destinationViewController.tweet = tweet
            destinationViewController.delegate = self
        }
        
        if identifier == "ReplyTweetSegueIdentifier" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let destinationViewController = navigationController.viewControllers[0] as! NewTweetViewController
            destinationViewController.user = User.currentUser
            // Going to have to refactor to get this working
            //destinationViewController.replyToTweet = tweet
        }

    }
    

}
