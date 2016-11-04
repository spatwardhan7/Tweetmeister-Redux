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
    
    private var tweetsViewController : UIViewController!
    private var profileViewController : UIViewController!
    var viewControllers : [UIViewController] = []
    var hamburgerViewController : HamburgerViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        tweetsViewController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        profileViewController = storyboard.instantiateViewController(withIdentifier: "profileViewController")
        
        viewControllers.append(tweetsViewController)
        viewControllers.append(profileViewController)
        

        
        hamburgerViewController.contentViewController = tweetsViewController
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuCell
        
        let titles = ["Timeline", "Profile", "Mentions"]
        cell.menuTitleLabel.text = titles[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
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
