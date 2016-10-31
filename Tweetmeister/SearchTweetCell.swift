//
//  SearchTweetCell.swift
//  Tweetmeister
//
//  Created by Patwardhan, Saurabh on 10/30/16.
//  Copyright © 2016 Saurabh Patwardhan. All rights reserved.
//

import UIKit

class SearchTweetCell: UITableViewCell {

    @IBOutlet weak var retweetNameLabel: UILabel!
    @IBOutlet weak var retweetView: UIView!
    @IBOutlet weak var retweetViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var mediaViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: ActiveLabel!
    let client = TwitterClient.sharedInstance


    
    var tweet : Tweet!{
        didSet {
            // Clean up Cell
            retweetNameLabel.text = ""
            retweetView.isHidden = true
            retweetViewHeight.constant = 0
            
            mediaImageView.layer.cornerRadius = 8.0
            mediaImageView.clipsToBounds = true
            mediaImageView.isHidden = true
            mediaViewHeight.constant = 0
            
            // Set views and labels depending on retweeted_status object
            if tweet.originalTweeter != nil {
                retweetViewHeight.constant = 19
                retweetView.isHidden = false
                retweetNameLabel.text = tweet.name + " Retweeted"
                
                nameLabel.text = tweet.originalTweeter?.name
                usernameLabel.text = "@"+(tweet.originalTweeter?.name)!
                tweetTextLabel.text = tweet.text?.replacingOccurrences(of: "RT ", with: "")
                if(tweet.originalTweeter?.profileUrl != nil){
                    posterImageView.setImageWith((tweet.originalTweeter?.profileUrl!)!)
                }
            }else {
                retweetViewHeight.constant = 0
                retweetView.isHidden = true
                nameLabel.text = tweet.name
                usernameLabel.text = tweet.username
                tweetTextLabel.text = tweet.text
                
                if(tweet.profileImageUrl != nil){
                    posterImageView.setImageWith(tweet.profileImageUrl!)
                }
            }
            
            let timeSinceNow = NSDate(timeIntervalSinceNow: (tweet.timestamp?.timeIntervalSinceNow)!)
            timeLabel.text = timeSinceNow.shortTimeAgoSinceNow()
            
            if(tweet.mediaUrl != nil){
                mediaImageView.setImageWith(tweet.mediaUrl!)
                mediaImageView.isHidden = false
                mediaViewHeight.constant = 120
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
