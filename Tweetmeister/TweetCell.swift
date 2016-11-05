//
//  TweetCell.swift
//  Tweetmeister
//
//  Created by Patwardhan, Saurabh on 10/27/16.
//  Copyright © 2016 Saurabh Patwardhan. All rights reserved.
//

import UIKit
import AFNetworking
import DateTools
import SwiftyJSON

protocol TweetCellDelegate {
    func onReplyButtonTapped(tweet: Tweet)
    func onMentionTapped(username : String)
    func onHashtagTapped(hashtag : String)
    func onProfileImageTapped(username : String)
}

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var separatorDotImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    //@IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: ActiveLabel!
    
    @IBOutlet weak var mediaViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var retweetNameLabel: UILabel!
    @IBOutlet weak var retweetView: UIView!
    @IBOutlet weak var retweetViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: SpringButton!
    @IBOutlet weak var likeButton: SpringButton!
    
    var isFav = 0
    var isRetweeted = 0
    let client = TwitterClient.sharedInstance
    var delegate: TweetCellDelegate?
    var tap : UITapGestureRecognizer?

    
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
                mediaViewHeight.constant = 220
            }
            
            isFav = (tweet.favorited) ?? 0
            isRetweeted = (tweet.retweeted) ?? 0
            
            setFavImage()
            setRetweetImage()

        }
    }
    
    func setRetweetImage(){
        if(isRetweeted == 0){
            retweetButton.setImage(UIImage(named: "retweet"), for: .normal)
        }else {
            retweetButton.setImage(UIImage(named: "retweet_green"), for: .normal)
        }
    }
    
    func setFavImage(){
        if(isFav == 0){
            likeButton.setImage(UIImage(named: "heart"), for: .normal)
        }else {
            likeButton.setImage(UIImage(named: "heart_red"), for: .normal)
        }
    }
    
    @IBAction func onReplyButton(_ sender: AnyObject) {
        delegate?.onReplyButtonTapped(tweet: tweet)
    }
    @IBAction func onRetweetButton(_ sender: AnyObject) {
        retweetButton.animation = "pop"
        if(isRetweeted == 0){
            let params = tweet.idStr
            client?.retweet(params: params!, success: {
                print("--- Home Timeline : Retweet success")
                }, failure: { (error : Error) in
                    print("--- Home Timeline : Retweet failed : \(error.localizedDescription)")
            })
            tweet.retweetCount += 1
            tweet.retweeted = 1
            isRetweeted = 1
            
        } else {
            var originalTweetId = tweet.idStr
            var tweetJSON = tweet.tweetJSON
            
            if(tweetJSON["retweeted_status"] != nil){
                let actualOriginalTweetId = tweetJSON["retweeted_status"]["id_str"].string!
                originalTweetId = actualOriginalTweetId
            }
            
            client?.showStatuses(params: originalTweetId!, success: { (originalTweet : NSDictionary) in
                let originalTweetJson = JSON(originalTweet)
                let retweetId = originalTweetJson["current_user_retweet"]["id_str"].string
                
                print("--- Home Timeline : retweetId : \(retweetId)")
                
                self.client?.unRetweet(params: retweetId!, success: {
                    print("--- Home Timeline : Un Retweet success")
                    }, failure: { (error : Error) in
                        print("--- Tweet Details : Un Retweet failed : \(error.localizedDescription)")
                })
                
                }, failure: { (error : Error) in
                    print("--- Home Timeline  : Show Statuses Failure : \(error.localizedDescription)")
            })
            tweet.retweetCount -= 1
            tweet.retweeted = 0
            isRetweeted = 0
        }
        setRetweetImage()
        retweetButton.animate()
    }
    
    @IBAction func onLikeButton(_ sender: AnyObject) {
        var params = [String : String]()
        params["id"] = tweet.idStr
        likeButton.animation = "pop"
        if(isFav == 0){
            client?.favoriteTweet(params: params, success: {
                print("--- Home Timeline : LIKE success")
                }, failure: { (error : Error) in
                    print("--- Home Timeline : LIKE failed : \(error.localizedDescription)")
            })
            tweet.favoritesCount += 1
            tweet.favorited = 1
            isFav = 1
        } else {
            client?.unfavoriteTweet(params: params, success: {
                print("--- Home Timeline: Un Favorite success")
                }, failure: { (error : Error) in
                    print("--- Home Timeline : Un Favorite failed : \(error.localizedDescription)")
            })
            tweet.favoritesCount -= 1
            tweet.favorited = 0
            isFav = 0
        }
        setFavImage()
        likeButton.animate()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.layer.cornerRadius = 5
        posterImageView.clipsToBounds = true
        
        self.selectionStyle = .none
        
        tweetTextLabel.handleURLTap { (url : URL) in
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        tweetTextLabel.handleMentionTap { (username : String) in
            print("--- username : \(username)")
            self.delegate?.onMentionTapped(username: username)
        }
        
        tweetTextLabel.handleHashtagTap { (hashtag : String) in
            self.delegate?.onHashtagTapped(hashtag: hashtag)
        }
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.tapImage(_:)))
        posterImageView.addGestureRecognizer(tap!)
        posterImageView.isUserInteractionEnabled = true
        
        // Initialization code
    }
    
    func tapImage(_ sender: UITapGestureRecognizer) {
        delegate?.onProfileImageTapped(username: tweet.username)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
