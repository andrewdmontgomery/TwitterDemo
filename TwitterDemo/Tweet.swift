//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Andrew Montgomery on 9/13/15.
//  Copyright (c) 2015 Andrew Montgomery. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var tweetID: Int?
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
    var retweetedUser: User?
    var favorited: Bool?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        retweetedStatus = dictionary["retweeted_status"] as? NSDictionary
        if retweetedStatus != nil {
            retweetedUser = User(dictionary: retweetedStatus!["user"] as! NSDictionary)
        }
        
        
        
        //createdAtString = dictionary["created_at"] as? String
        let createAtStringOriginal = dictionary["created_at"] as? String
        
        // NSDateFormatter is very expensive.
        // Consider making it static, and setting 'createdAt' lazily
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createAtStringOriginal!)
        
        if createdAt != nil {
            let shortFormatter = NSDateFormatter()
            shortFormatter.dateFormat = "M/d/yy"
            createdAtString = shortFormatter.stringFromDate(createdAt!)
        }
        
        favorited = dictionary["favorited"] as? Bool
        tweetID = dictionary["id"] as? Int
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    
}
