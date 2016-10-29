//
//  TweetsViewController.swift
//  Tweetmeister
//
//  Created by Patwardhan, Saurabh on 10/25/16.
//  Copyright © 2016 Saurabh Patwardhan. All rights reserved.
//

import UIKit
import MBProgressHUD

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets : [Tweet]!
    let client = TwitterClient.sharedInstance!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationbar()
        loadHomeTimelineTweets(withProgressHUD: true)
        
        // Do any additional setup after loading the view.
    }
    
    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160
        tableView.insertSubview(refreshControl, at: 0)
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
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        loadHomeTimelineTweets(withProgressHUD: false)
    }
    
    func loadHomeTimelineTweets(withProgressHUD : Bool){
        print("--- Tweets VC : calling home time line")
        
        if withProgressHUD{
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        client.homeTimeline(success: { (tweets : [Tweet]) in
            print("--- Tweets VC : home time line success: got \(tweets.count) tweets")
            
            self.tweets = tweets
            self.tableView.reloadData()
            self.cleanUpUI()
            
            }, failure: { (error : Error) in
                self.cleanUpUI()
                print("---- Tweets VC : homeTimeline failure : \(error.localizedDescription)")
        })
        
    }
    
    func cleanUpUI(){
        self.refreshControl.endRefreshing()
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    @IBAction func onLogoutButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.logout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        /*
         let cell = sender as! UITableViewCell
         let indexPath = tableView.indexPath(for: cell)
         let movie = movies![(indexPath! as NSIndexPath).row]
         
         let detailViewController = segue.destination as! DetailViewController
         detailViewController.movie = movie
 
         */
        
        if(segue.identifier == "tweetDetailsSegue") {
            let cell = sender as! TweetCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[(indexPath! as NSIndexPath).row]
            
            let tweetDetailsViewController = segue.destination as! TweetDetailsViewController
            tweetDetailsViewController.tweet = tweet
        }
        
        
     }
 
    
}
