//
//  TweetsViewController.swift
//  Tweetmeister
//
//  Created by Patwardhan, Saurabh on 10/25/16.
//  Copyright © 2016 Saurabh Patwardhan. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    var tweets : [Tweet]!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationbar()
        let client = TwitterClient.sharedInstance!
        
        print("--- Tweets VC : calling home time line")
        client.homeTimeline(success: { (tweets : [Tweet]) in
            self.tweets = tweets
            
            print("--- Tweets VC : home time line success: got \(tweets.count) tweets")
            
            for tweet in tweets{
                print(tweet.text)
            }
            
            }, failure: { (error : Error) in
                print("---- Tweets VC : homeTimeline failure : \(error.localizedDescription)")
        })
        
        // Do any additional setup after loading the view.
    }
    
    func setupNavigationbar(){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 2 , height: 2))
        imageView.contentMode = UIViewContentMode.center
        let image = UIImage(named: "Twitter_Logo_Blue_Small")
        imageView.image = image
        self.navigationItem.titleView = imageView
    }

    @IBAction func onLogoutButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.logout()
        
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
