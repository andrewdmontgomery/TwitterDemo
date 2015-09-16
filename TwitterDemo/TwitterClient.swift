//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by Andrew Montgomery on 9/10/15.
//  Copyright (c) 2015 Andrew Montgomery. All rights reserved.
//

import UIKit

let twitterConsumerKey = "O8bcIzj4rqN96R7FYxabD9t1S"
let twitterConsumerSecret = "Xr5BmYN5UC5fEKWjPfNqbkKkgezIKB5Lb8xo1dlgLt4WWYRuQT"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
   
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)

        }
        
        return Static.instance
    }
    
    func homeTimeLineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            //println("home timeline: \(response)")
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            
            completion(tweets: tweets, error: nil)
        }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            println("error getting current home timeline: \(error)")
            completion(tweets: nil, error: error)
        })
    }
    
    func postStatusWithParams(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("post status: \(response)")
            var tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("error posting status")
            completion(tweet: nil, error: error)
        }
    }
    
    func postFavoriteWithParams(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/favorites/create.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("create favorite status: \(response)")
            completion(tweet: nil, error: nil)
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("error creating favorite status: \(error)")
            completion(tweet: nil, error: error)
        }
    }
    
    func destroyFavoriteWithParams(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/favorites/destroy.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("destroy post status: \(response)")
            completion(tweet: nil, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error destroying favorite status: \(error)")
                completion(tweet: nil, error: error)
        }
    }

    func postRetweetWithParams(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        let tweetID = params?.objectForKey("id") as? Int
        if tweetID != nil {
            POST("1.1/statuses/retweet/\(tweetID!).json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println("post retweet status: \(response)")
                var tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
                }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("error posting retweet status: \(error)")
                    completion(tweet: nil, error: error)
            }

        }
    }
    
//    func postRetweetWithParams(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
//        POST("1.1/statuses/retweet/:id.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//            println("post retweet status: \(response)")
//            completion(tweet: nil, error: nil)
//        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
//                println("error posting retweet status: \(error)")
//                completion(tweet: nil, error: error)
//        }
//    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token & redirect to authorization page
        // Clean up any cached access tokens (because the next step assumes we need a new one)
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            println("Got the request token")
            // Once we have a token, head to the Twitter webpage
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            
        // If that worked, we need an access token
        }) { (error: NSError!) -> Void in
            println("Failed to get request token")
            self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken:BDBOAuth1Credential!) -> Void in
            println("Got the access token!")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                //println("user: \(response)")
                var user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                println("user: \(user.name)")
                self.loginCompletion?(user: user, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error:NSError!) -> Void in
                println("error getting current user")
                self.loginCompletion?(user: nil, error: error)
            })
        }) { (error:NSError!) -> Void in
            println("Failed to receive access token")
            self.loginCompletion?(user: nil, error: error)
        }

    }
}
