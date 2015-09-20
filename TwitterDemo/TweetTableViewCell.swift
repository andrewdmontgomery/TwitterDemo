//
//  TweetTableViewCell.swift
//  TwitterDemo
//
//  Created by Andrew Montgomery on 9/13/15.
//  Copyright (c) 2015 Andrew Montgomery. All rights reserved.
//

import UIKit

let tweetTableViewCellReuseIdentifier = "TweetCell"

@objc protocol TweetTableViewCellDelegate {
    optional func tweetTableViewCell(tweetTableViewCell: TweetTableViewCell, didToggleFavoriteForTweet tweet: Tweet?, withParams params: [String:Int])
    optional func tweetTableViewCell(tweetTableViewCell: TweetTableViewCell, didTapReplyForTweet tweet: Tweet?)
}

class TweetTableViewCell: UITableViewCell {

    var tweet: Tweet? {
        didSet {
            nameLabel.text = tweet?.user?.name
            screenNameLabel.text = tweet?.user?.screenname
            let profileImageURLString = tweet?.user?.profileImageUrl
            //print("profileImageURL: \(profileImageURLString)")
            if profileImageURLString != nil {
                print("profileImageURL: \(profileImageURLString)")
                let profileImageURL = NSURL(string: profileImageURLString!)
                if profileImageURL != nil {
                    profileImageView.setImageWithURL(profileImageURL)
                }
            }
            //dateLabel.text = tweet?.createdAtString
            tweetTextLabel.text = tweet?.text
            dateLabel.text = tweet?.createdAtString
            
            if favoritedButton != nil {
                updateFavoritedButtonImage()
            }

        }
    }
    
    var profileImageURL: NSURL?
    
    private var favoriteButtonImage: UIImage?
    
    weak var delegate: TweetTableViewCellDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var favoritedButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        
        updateFavoritedButtonImage()
        
        // Fix the length of the nameLabel view for autolayout
        //nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        
   }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateFavoritedButtonImage()
        
        // Fix the length of the nameLabel view for autolayout
        //nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateFavoritedButtonImage() {
        if tweet != nil {
            if favoritedButton != nil {
                if tweet!.favorited == true {
                    favoriteButtonImage = UIImage(named: "favorite_on")
                } else {
                    favoriteButtonImage = UIImage(named: "favorite")
                }
                favoritedButton.setImage(favoriteButtonImage, forState: UIControlState.Normal)
            }
        }
    }

    
    @IBAction func onReply(sender: AnyObject) {
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        if let tweetID = tweet?.tweetID {
            // this should be done somewhere else.
            let params = ["id":tweetID]
            print("retweet params: \(params)")
            TwitterClient.sharedInstance.postRetweetWithParams(params, completion: { (tweet, error) -> () in
                // nothing to do here yet
            })
        }

    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        if tweet != nil {
            let tweetID = tweet!.tweetID
            if tweetID != nil {
                let params = ["id" : tweet!.tweetID!]
                delegate?.tweetTableViewCell!(self, didToggleFavoriteForTweet: tweet!, withParams: params)
            }
        }
    }    
}
