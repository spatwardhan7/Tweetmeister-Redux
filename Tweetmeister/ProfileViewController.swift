//
//  ProfileViewController.swift
//  Tweetmeister
//
//  Created by Patwardhan, Saurabh on 10/30/16.
//  Copyright © 2016 Saurabh Patwardhan. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var posterBackgroundImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var verifiedImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: ActiveLabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var urlLabel: ActiveLabel!
    @IBOutlet weak var urlViewHeight: NSLayoutConstraint!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    
    @IBOutlet weak var clipImageView: UIImageView!
    var username : String!
    var userProfile : User!
    let client = TwitterClient.sharedInstance!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlLabel.handleURLTap { (url : URL) in
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        descriptionLabel.handleURLTap { (url : URL) in
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        posterImageView.layer.cornerRadius = 8.0
        posterImageView.clipsToBounds = true

        self.navigationController?.navigationBar.tintColor = UIColor.white;

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        MBProgressHUD.showAdded(to: self.view, animated: true)
        loadUserDetails()
        
        // Do any additional setup after loading the view.
    }
    
    
    func loadUserDetails(){
        client.getUserDetails(params: username, success: { (user : User) in
            self.userProfile = user
            self.updateLabels()
            MBProgressHUD.hide(for: self.view, animated: true)
        }) { (error : Error) in
            print("--- Profile View failed to get user profile : \(error.localizedDescription)")
        }
    }
    
    func updateLabels(){
        if(userProfile.profileBannerUrl != nil){
            //posterBackgroundImageView.setImageWith(userProfile.profileBannerUrl!)
            StaticHelper.fadeInImage(posterImageView: posterBackgroundImageView, posterImageUrl: userProfile.profileBannerUrl!)
        }
        
        if(userProfile.profileUrl != nil ){
            //posterImageView.setImageWith(userProfile.profileUrl!)
            StaticHelper.fadeInImage(posterImageView: posterImageView, posterImageUrl: userProfile.profileUrl!)
        }
        
        nameLabel.text = userProfile.name
        usernameLabel.text = "@" + userProfile.screenName!
        descriptionLabel.text = userProfile.tagline
        
        if(userProfile.verified == true) {
            verifiedImageView.isHidden = false
        }
        
        if(userProfile.location != nil ){
            locationLabel.text = userProfile.location
        }
        
        if(userProfile.descriptionUrl != nil){
            urlLabel.text = userProfile.descriptionUrl
        } else {
            urlViewHeight.constant = 0
            clipImageView.isHidden = true
            urlLabel.isHidden = true
        }
        
        
        let followersNum = numString(num: userProfile.followersCount!)
        let followingNum = numString(num: userProfile.followingCount!)
        followersLabel.text = followersNum + " FOLLOWERS"
        followingLabel.text = followingNum + " FOLLOWING"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numString(num: Int) -> String{
        var returnString = "0"
        if(num < 1000){
            returnString = "\(num)"
        } else {
            let numFloat = Float(num)
            let thousand : Float = 1000
            let result = numFloat/thousand
            returnString = "\(result)k"
        }
        
        return returnString
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
