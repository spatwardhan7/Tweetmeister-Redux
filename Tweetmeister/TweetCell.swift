//
//  TweetCell.swift
//  Tweetmeister
//
//  Created by Patwardhan, Saurabh on 10/27/16.
//  Copyright © 2016 Saurabh Patwardhan. All rights reserved.
//

import UIKit
import AFNetworking
class TweetCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var separatorDotImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var retweetNameLabel: UILabel!
    @IBOutlet weak var retweetView: UIView!
    @IBOutlet weak var retweetViewHeight: NSLayoutConstraint!
    var tweet : Tweet!{
        didSet {
            retweetNameLabel.text = ""
            retweetView.isHidden = true
            retweetViewHeight.constant = 0

            
            if tweet.originalTweeter != nil {
                retweetViewHeight.constant = 19
                retweetView.isHidden = false
                retweetNameLabel.text = tweet.name + " Retweeted"
                
                nameLabel.text = tweet.originalTweeter?.name
                usernameLabel.text = "@"+(tweet.originalTweeter?.name)!
                tweetTextLabel.text = tweet.text?.replacingOccurrences(of: "RT ", with: "")
                if(tweet.originalTweeter?.profileUrl != nil){
                    //StaticHelper.fadeInImage(posterImageView: posterImageView, posterImageUrl: (tweet.originalTweeter?.profileUrl!)!)
                    posterImageView.setImageWith((tweet.originalTweeter?.profileUrl!)!)
                }
            }else {
                retweetViewHeight.constant = 0
                retweetView.isHidden = true
                nameLabel.text = tweet.name
                usernameLabel.text = tweet.username
                tweetTextLabel.text = tweet.text
                
                if(tweet.profileImageUrl != nil){
                    //StaticHelper.fadeInImage(posterImageView: posterImageView, posterImageUrl: tweet.profileImageUrl!)
                    posterImageView.setImageWith(tweet.profileImageUrl!)
                }
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
