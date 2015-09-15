//
//  TweetDetailViewController.swift
//  TwitterDemo
//
//  Created by Andrew Montgomery on 9/14/15.
//  Copyright (c) 2015 Andrew Montgomery. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    var tweet: Tweet?
    
    private var favoriteButtonImage: UIImage?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var favoritedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if tweet != nil {
            nameLabel.text = tweet!.user?.name
            screenNameLabel.text = tweet!.user?.screenname
            tweetTextLabel.text = tweet!.text
            
            if let profileImageURLString = tweet!.user?.profileImageUrl {
                let profileImageURL = NSURL(string: profileImageURLString)
                profileImageView.setImageWithURL(profileImageURL)
            }
            
            println("favorited: \(tweet!.favorited)")
            
            
            
            
            updateFavoritedButtonImage()

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

    func updateFavoritedButtonImage() {
        if favoritedButton != nil {
            if tweet!.favorited == true {
                favoriteButtonImage = UIImage(named: "favorite_on")
            } else {
                favoriteButtonImage = UIImage(named: "favorite")
            }
            favoritedButton.setImage(favoriteButtonImage, forState: UIControlState.Normal)
        }
    }
    
    @IBAction func onToggleFavorite(sender: AnyObject) {
        if tweet != nil {
            var params = ["id" : tweet!.tweetID!]
            if tweet!.favorited == false {
                TwitterClient.sharedInstance.postFavoriteWithParams(params, completion: { (tweet, error) -> () in
                    self.tweet?.favorited = true
                    self.updateFavoritedButtonImage()
                })
            } else if tweet?.favorited == true {
                TwitterClient.sharedInstance.destroyFavoriteWithParams(params, completion: { (tweet, error) -> () in
                    self.tweet?.favorited = false
                    self.updateFavoritedButtonImage()
                })
            }
        }
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
    }

    @IBAction func onReply(sender: AnyObject) {
    }
 
    
}
