//
//  ProfileTableViewCell.swift
//  TwitterDemo
//
//  Created by Andrew Montgomery on 9/21/15.
//  Copyright © 2015 Andrew Montgomery. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let statusesCountInt = User.currentUser!.statusesCount {
            tweetCount.text = "\(statusesCountInt)"
        } else {
            tweetCount.text = "0"
        }
        
        if let followingCountInt = User.currentUser!.followingCount {
            followingCount.text = "\(followingCountInt)"
        } else {
            followingCount.text = "0"
        }
        
        if let followersCountInt = User.currentUser!.followersCount {
            followersCount.text = "\(followersCountInt)"
        } else {
            followersCount.text = "0"
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
