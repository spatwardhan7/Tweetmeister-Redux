//
//  MenuViewController.swift
//  Tweetmeister
//
//  Created by Patwardhan, Saurabh on 11/3/16.
//  Copyright © 2016 Saurabh Patwardhan. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    private var tweetsNavController : UINavigationController!
    private var mentionsNavController : UINavigationController!
    
    
    private var tweetsViewController : UIViewController!
    private var profileViewController : UIViewController!
    var viewControllers : [UIViewController] = []
    var hamburgerViewController : HamburgerViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 220
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        tweetsNavController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController") as! UINavigationController
        let tVC = tweetsNavController.topViewController as! TweetsViewController
        tVC.isHomeTimeline = true
        tVC.isMentionsTimeline = false
        
        mentionsNavController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController") as! UINavigationController
        let mentionsViewController = mentionsNavController.topViewController as! TweetsViewController
        mentionsViewController.isHomeTimeline = false
        mentionsViewController.isMentionsTimeline = true
        
        profileViewController = storyboard.instantiateViewController(withIdentifier: "newProfileViewNavigationController")

        hamburgerViewController.contentViewController = tweetsNavController
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuCell
        
        let titles = ["Timeline", "Profile", "Mentions", "Accounts"]
        cell.menuTitleLabel.text = titles[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            hamburgerViewController.contentViewController = tweetsNavController
        } else if indexPath.row == 1 {
            hamburgerViewController.contentViewController = profileViewController
        } else if indexPath.row == 2 {
            hamburgerViewController.contentViewController = mentionsNavController
        }
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
