//
//  TweetDetailsViewController.swift
//  Tweetmeister
//
//  Created by Patwardhan, Saurabh on 10/27/16.
//  Copyright © 2016 Saurabh Patwardhan. All rights reserved.
//

import UIKit
import SwiftyJSON

class TweetDetailsViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var verifiedImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var retweetNameLabel: UILabel!
    @IBOutlet weak var retweetView: UIView!
    @IBOutlet weak var retweetViewHeightConstraint: NSLayoutConstraint!
    
    var tweet : Tweet!
    let client = TwitterClient.sharedInstance
    var isFav = 0
    var isRetweeted = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("--- Tweet Details : got tweet : \(tweet)")
        setDetails()
        
        // Do any additional setup after loading the view.
    }
    
    func setDetails(){

        // Clean up View
        retweetNameLabel.text = ""
        retweetView.isHidden = true
        retweetViewHeightConstraint.constant = 0
        
        if tweet.originalTweeter != nil {
            retweetViewHeightConstraint.constant = 19
            retweetView.isHidden = false
            
            retweetNameLabel.text = tweet.name + " Retweeted"
            nameLabel.text = tweet.originalTweeter?.name
            usernameLabel.text = "@"+(tweet.originalTweeter?.name)!
            tweetTextLabel.text = tweet.text?.replacingOccurrences(of: "RT ", with: "")
            
            if(tweet.originalTweeter?.profileUrl != nil){
                posterImageView.setImageWith((tweet.originalTweeter?.profileUrl!)!)
            }
        } else {
            retweetViewHeightConstraint.constant = 0
            retweetView.isHidden = true
            
            nameLabel.text = tweet.name
            usernameLabel.text = tweet.username
            tweetTextLabel.text = tweet.text
            
            if(tweet.profileImageUrl != nil){
                posterImageView.setImageWith(tweet.profileImageUrl!)
            }
        
        }
    
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy, hh:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let dateString = formatter.string(from: tweet.timestamp!)
        
        timeLabel.text = dateString
        retweetCountLabel.text = "\(tweet.retweetCount)"
        likeCountLabel.text = "\(tweet.favoritesCount)"
        
        if (tweet.verified == true){
            verifiedImageView.isHidden = false
        }
        
        isFav = (tweet.favorited) ?? 0
        isRetweeted = (tweet.retweeted) ?? 0
        
        setFavImage()
        setRetweetImage()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweetButton(_ sender: AnyObject) {
        
        if(isRetweeted == 0){
            let params = tweet.idStr
            client?.retweet(params: params!, success: {
                print("--- Tweet Details : Retweet success")
                }, failure: { (error : Error) in
                    print("--- Tweet Details : Retweet failed : \(error.localizedDescription)")
                    self.retweetCountLabel.text = "\(self.tweet.retweetCount)"
            })
            retweetCountLabel.text = "\(Int(retweetCountLabel.text!)! + 1)"
            tweet.retweetCount  += 1
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
                
                print("--- Tweet Details: retweetId : \(retweetId)")
                
                self.client?.unRetweet(params: retweetId!, success: {
                    print("--- Tweet Details: Un Retweet success")
                    }, failure: { (error : Error) in
                        print("--- Tweet Details : Un Retweet failed : \(error.localizedDescription)")
                        self.retweetCountLabel.text = "\(self.tweet.retweetCount)"
                })
                
                }, failure: { (error : Error) in
                    self.retweetCountLabel.text = "\(self.tweet.retweetCount)"
                print("--- Tweet Details : Show Statuses Failure : \(error.localizedDescription)")
            })
            retweetCountLabel.text = "\(Int(retweetCountLabel.text!)! - 1)"
            tweet.retweetCount -= 1
            tweet.retweeted = 0
            isRetweeted = 0
        }
        setRetweetImage()
    }
    
    @IBAction func onLikeButton(_ sender: AnyObject) {
        var params = [String : String]()
        params["id"] = tweet.idStr
        
        if(isFav == 0){
            client?.favoriteTweet(params: params, success: {
                print("--- Tweet Details : LIKE success")
                }, failure: { (error : Error) in
                    print("--- Tweet Details : LIKE failed : \(error.localizedDescription)")
                    self.likeCountLabel.text = "\(self.tweet.favoritesCount)"
            })
            likeCountLabel.text = "\(Int(likeCountLabel.text!)! + 1)"
            tweet.favoritesCount += 1
            tweet.favorited = 1
            isFav = 1
        } else {
            client?.unfavoriteTweet(params: params, success: {
                print("--- Tweet Details: Un Favorite success")
                }, failure: { (error : Error) in
                    print("--- Tweet Details : Un Favorite failed : \(error.localizedDescription)")
                    self.likeCountLabel.text = "\(self.tweet.favoritesCount)"
            })
            likeCountLabel.text = "\(Int(likeCountLabel.text!)! - 1)"
            tweet.favoritesCount -= 1
            tweet.favorited = 0
            isFav = 0
        }
        setFavImage()
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if(segue.identifier == "composeReplySegue"){
            let composeViewController = segue.destination as! ComposeViewController
            composeViewController.tweet = tweet
            
        }
     }
}
