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
   
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)

        }
        
        return Static.instance
    }
}
