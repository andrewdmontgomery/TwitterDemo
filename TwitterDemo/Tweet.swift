//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Andrew Montgomery on 9/13/15.
//  Copyright (c) 2015 Andrew Montgomery. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var retweetedStatus: NSDictionary?
    var retweeted: Bool? {
        get {
            if retweetedStatus == nil {
                return false
            } else {
                return true
            }
        }
    }
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        retweetedStatus = dictionary["retweeted_status"] as? NSDictionary
        
        // NSDateFormatter is very expensive.
        // Consider making it static, and setting 'createdAt' lazily
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    
}
