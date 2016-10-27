//
//  TweetsViewController.swift
//  Tweetmeister
//
//  Created by Patwardhan, Saurabh on 10/25/16.
//  Copyright © 2016 Saurabh Patwardhan. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets : [Tweet]!
    let client = TwitterClient.sharedInstance!
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationbar()
        loadHomeTimelineTweets()
        
        // Do any additional setup after loading the view.
    }
    
    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160
    }
    
    func setupNavigationbar(){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 2 , height: 2))
        imageView.contentMode = UIViewContentMode.center
        let image = UIImage(named: "Twitter_Logo_Blue_Small")
        imageView.image = image
        self.navigationItem.titleView = imageView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets{
            return tweets.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    
    
    func loadHomeTimelineTweets(){
        print("--- Tweets VC : calling home time line")
        client.homeTimeline(success: { (tweets : [Tweet]) in
            print("--- Tweets VC : home time line success: got \(tweets.count) tweets")
            self.tweets = tweets
            
    
            
            for tweet in tweets{
                print("-- Tweet from: \(tweet.name) screen name: \(tweet.username)")
            }
            self.tableView.reloadData()
            
            }, failure: { (error : Error) in
                print("---- Tweets VC : homeTimeline failure : \(error.localizedDescription)")
        })
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
