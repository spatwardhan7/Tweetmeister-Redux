//
//  TweetCell.swift
//  Tweetmeister
//
//  Created by Patwardhan, Saurabh on 10/27/16.
//  Copyright © 2016 Saurabh Patwardhan. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var separatorDotImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet : Tweet!{
        didSet {
            nameLabel.text = tweet.name
            usernameLabel.text = tweet.username
            tweetTextLabel.text = tweet.text
            
            if(tweet.profileImageUrl != nil){
                StaticHelper.fadeInImage(posterImageView: posterImageView, posterImageUrl: tweet.profileImageUrl!)
            }
            
        
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.layer.cornerRadius = 5
        posterImageView.clipsToBounds = true
        
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
