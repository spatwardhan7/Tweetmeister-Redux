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
        StaticHelper.fadeInImage(posterImageView: posterImageView, posterImageUrl: tweet.profileImageUrl!)
        nameLabel.text = tweet.name
        usernameLabel.text = tweet.username
        tweetTextLabel.text = tweet.text
        
        
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweetButton(_ sender: AnyObject) {
        
        if(isRetweeted == 0){
            let params = tweet.idStr
            client?.retweet(params: params, success: {
                print("--- Tweet Details : Retweet success")
                }, failure: { (error : Error) in
                    print("--- Tweet Details : Retweet failed : \(error.localizedDescription)")
                    self.retweetCountLabel.text = "\(self.tweet.retweetCount)"
            })
            retweetCountLabel.text = "\(Int(retweetCountLabel.text!)! + 1)"
            isRetweeted = 1
            
        } else {
            var originalTweetId = tweet.idStr
            var tweetJSON = tweet.tweetJSON
            
            if(tweetJSON["retweeted_status"] != nil){
                let actualOriginalTweetId = tweetJSON["retweeted_status"]["id_str"].string!
                originalTweetId = actualOriginalTweetId
            }
            
            client?.showStatuses(params: originalTweetId, success: { (originalTweet : NSDictionary) in
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
            isRetweeted = 0
        }
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
            isFav = 1
        } else {
            client?.unfavoriteTweet(params: params, success: {
                print("--- Tweet Details: Un Favorite success")
                }, failure: { (error : Error) in
                    print("--- Tweet Details : Un Favorite failed : \(error.localizedDescription)")
                    self.likeCountLabel.text = "\(self.tweet.favoritesCount)"
            })
            likeCountLabel.text = "\(Int(likeCountLabel.text!)! - 1)"
            isFav = 0
        }
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
