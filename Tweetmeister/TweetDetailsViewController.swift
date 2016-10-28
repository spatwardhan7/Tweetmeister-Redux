//
//  TweetDetailsViewController.swift
//  Tweetmeister
//
//  Created by Patwardhan, Saurabh on 10/27/16.
//  Copyright © 2016 Saurabh Patwardhan. All rights reserved.
//

import UIKit

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("--- Tweet Details : got tweet : \(tweet)")
        setDetails()

        // Do any additional setup after loading the view.
    }
    
    func setDetails(){
        StaticHelper.fadeInImage(posterImageView: posterImageView, posterImageUrl: tweet.profileImageUrl!)
        nameLabel.text = tweet.name
        usernameLabel.text = "@" + tweet.username
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
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
