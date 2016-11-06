//
//  NewProfileViewController.swift
//  Tweetmeister
//
//  Created by Patwardhan, Saurabh on 11/5/16.
//  Copyright © 2016 Saurabh Patwardhan. All rights reserved.
//

import UIKit

class NewProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var username:String!
    @IBOutlet weak var tableView: UITableView!
    let client = TwitterClient.sharedInstance!
    var tweets = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        tableView.register(UINib(nibName: "ProfileViewCell", bundle : nil), forCellReuseIdentifier: "profileViewCell")
        tableView.register(UINib(nibName: "TweetCellNib", bundle : nil), forCellReuseIdentifier: "tweetCellNib")
        getUserTweets()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        } else {
            return tweets.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileViewCell") as! ProfileViewCell
            
            if(username == nil){
                cell.username = User.currentUser?.screenName
            } else {
                cell.username = username
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCellNib", for: indexPath) as! TweetCellNib
            cell.tweet = tweets[indexPath.row]
            return cell
        }
    }
    
    func getUserTweets(){
        var params : String!
        if(username == nil ){
            params = User.currentUser?.screenName
        } else {
            params = username
        }
        client.getUserTweets(params: params, success: { (tweets : [Tweet]) in
                self.tweets = tweets
            self.tableView.reloadData()
            }, failure: { (error : Error) in
        })
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
