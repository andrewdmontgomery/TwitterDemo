//
//  ProfileTableViewCell.swift
//  TwitterDemo
//
//  Created by Andrew Montgomery on 9/21/15.
//  Copyright © 2015 Andrew Montgomery. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    var user: User? {
        didSet {
            if user != nil {
                if let statusesCountInt = user!.statusesCount {
                    tweetCount.text = "\(statusesCountInt)"
                } else {
                    tweetCount.text = "0"
                }
                
                if let followingCountInt = user!.followingCount {
                    followingCount.text = "\(followingCountInt)"
                } else {
                    followingCount.text = "0"
                }
                
                if let followersCountInt = user!.followersCount {
                    followersCount.text = "\(followersCountInt)"
                } else {
                    followersCount.text = "0"
                }
            }
        }
    }
    
    @IBOutlet weak var tweetCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        print(user)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
