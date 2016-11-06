//
//  SearchViewController.swift
//  Tweetmeister
//
//  Created by Patwardhan, Saurabh on 10/30/16.
//  Copyright © 2016 Saurabh Patwardhan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetCellNibDelegate, ComposeViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var tweets : [Tweet]!
    let client = TwitterClient.sharedInstance!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TweetCellNib", bundle : nil), forCellReuseIdentifier: "tweetCellNib")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 180
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets{
            return tweets.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCellNib", for: indexPath) as! TweetCellNib
        
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func onHashtagTapped(hashtag : String){
        client.searchTweets(params: hashtag, success: { (searchTweets : [Tweet]) in
            print("--- got search tweets : \(searchTweets.count)")
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let searchViewController = storyboard.instantiateViewController(withIdentifier: "searchViewController") as! SearchViewController
            searchViewController.tweets = searchTweets
            self.navigationController?.pushViewController(searchViewController, animated: true)
            
            
            
            
        }) { (error : Error) in
            print("--- searctTweets failure : \(error.localizedDescription)")
        }
    }
    
    func onProfileImageTapped(username : String){
        print("--- tweets view got user name : \(username)")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
        profileViewController.username = username
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func onMentionTapped(username : String){
        print("--- tweets view got user name : \(username)")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
        profileViewController.username = username
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func onReplyButtonTapped(tweet: Tweet) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let composeViewController = storyboard.instantiateViewController(withIdentifier: "composeViewController") as! ComposeViewController
        
        composeViewController.tweet = tweet
        composeViewController.delegate = self
        present(composeViewController, animated: true) {
        }
        
    }
    
    func didComposeTweet(tweet: Tweet) {
        tweetComposed(tweet: tweet)
    }
    
    func tweetComposed(tweet : Tweet){
        self.tweets.insert(tweet, at: 0)
        tableView.reloadData()
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
