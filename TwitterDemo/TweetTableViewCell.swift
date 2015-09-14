//
//  TweetTableViewCell.swift
//  TwitterDemo
//
//  Created by Andrew Montgomery on 9/13/15.
//  Copyright (c) 2015 Andrew Montgomery. All rights reserved.
//

import UIKit

let tweetTableViewCellReuseIdentifier = "TweetCell"

class TweetTableViewCell: UITableViewCell {

    var tweet: Tweet? {
        didSet {
            println("tweet was set")
            //nameLabel.text = tweet
            nameLabel.text = tweet?.user?.name
            screenNameLabel.text = tweet?.user?.screenname
            var profileImageURL: NSURL?
            let profileImageURLString = tweet?.user?.profileImageUrl
            if profileImageURLString != nil {
                let profileImageURL = NSURL(string: profileImageURLString!)
                if profileImageURL != nil {
                    profileImageView.setImageWithURL(profileImageURL)
                }
            }
            //dateLabel.text = tweet?.createdAtString
            tweetTextLabel.text = tweet?.text
        }
    }
    
    var profileImageURL: NSURL?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!

    @IBOutlet weak var retweeterNameLabel: UILabel!
    @IBOutlet weak var retweetedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onReply(sender: AnyObject) {
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
    }

    
}
