//
//  ProfileHeaderTableViewCell.swift
//  TwitterDemo
//
//  Created by Andrew Montgomery on 9/21/15.
//  Copyright © 2015 Andrew Montgomery. All rights reserved.
//

import UIKit

class ProfileHeaderTableViewCell: UITableViewCell {

    var user: User? {
        didSet {
            if user != nil {
                nameLabel.text = user!.name
                screenNameLabel.text = user!.screenname
                
                if let profileBackgroundImageURLString = user!.profileBackgroundImageUrl {
                    let profileBackgroundImageURL = NSURL(string: profileBackgroundImageURLString)
                    if profileBackgroundImageURL != nil {
                        profileBackgroundImageView.setImageWithURL(profileBackgroundImageURL)
                    }
                }
                
                if let profileImageURLString = user!.profileImageUrl {
                    let profileImageURL = NSURL(string: profileImageURLString)
                    if profileImageURL != nil {
                        profileImageView.setImageWithURL(profileImageURL)
                    }
                }
                
                print("name: \(nameLabel.text)")
                print("screenName: \(screenNameLabel.text)")
                print("profileImageView: \(profileImageView)")
                print("profileBackgroundImageView: \(profileBackgroundImageView)")
            }
        }
    }
    
    @IBOutlet weak var profileBackgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
