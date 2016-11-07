//
//  ProfileViewCell.swift
//  Tweetmeister
//
//  Created by Patwardhan, Saurabh on 11/5/16.
//  Copyright © 2016 Saurabh Patwardhan. All rights reserved.
//

import UIKit

class ProfileViewCell: UITableViewCell, UIScrollViewDelegate {

    @IBOutlet weak var scrollHolderView: UIView!
    @IBOutlet weak var holderHeight: NSLayoutConstraint!
    @IBOutlet weak var opacityView: UIView!
    @IBOutlet weak var posterBackgroundImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var verifiedImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: ActiveLabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var urlLabel: ActiveLabel!
    @IBOutlet weak var locationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var urlViewHeight: NSLayoutConstraint!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var pinImageView: UIImageView!
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var clipImageView: UIImageView!
    @IBOutlet weak var pControl: UIPageControl!
    
    var username : String!{
        didSet{
            loadUserDetails()
        }
    }
    var userProfile : User!
    let client = TwitterClient.sharedInstance!
    var originalHeight : CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        urlLabel.handleURLTap { (url : URL) in
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        descriptionLabel.handleURLTap { (url : URL) in
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        opacityView.alpha = 0
        posterImageView.layer.cornerRadius = 8.0
        posterImageView.clipsToBounds = true
        
        originalHeight = holderHeight.constant
        
    }
    
    func loadUserDetails(){
        client.getUserDetails(params: username, success: { (user : User) in
            self.userProfile = user
            self.updateLabels()
        }) { (error : Error) in
            print("--- Profile View failed to get user profile : \(error.localizedDescription)")
        }
    }
    
    func updateLabels(){
        if(userProfile.profileBannerUrl != nil){
            StaticHelper.fadeInImage(posterImageView: posterBackgroundImageView, posterImageUrl: userProfile.profileBannerUrl!)
        }
        
        if(userProfile.profileUrl != nil ){
            StaticHelper.fadeInImage(posterImageView: posterImageView, posterImageUrl: userProfile.profileUrl!)
        }
        
        nameLabel.text = userProfile.name
        usernameLabel.text = "@" + userProfile.screenName!
        descriptionLabel.text = userProfile.tagline
        
        if(userProfile.verified == true) {
            verifiedImageView.isHidden = false
        }
        
        if(userProfile.location != nil && userProfile.location != "" ){
            locationLabel.text = userProfile.location
        } else {
            locationViewHeight.constant = 0
            locationLabel.isHidden = true
            pinImageView.isHidden = true
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
        let tweetsNum = numString(num: userProfile.tweetsCount!)
        followersLabel.text = followersNum
        followingLabel.text = followingNum
        tweetsLabel.text = tweetsNum
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
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        
        let xOffset = scrollView.bounds.width * CGFloat(pControl.currentPage)
        
        scrollView.setContentOffset(CGPoint(x: xOffset, y:0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print ("decelerate")
        pControl.currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("did scroll")
        let offset = scrollView.contentOffset.x / scrollView.bounds.width
        
        self.opacityView.alpha = CGFloat(offset * 0.5)

    }
    
    func updateHeight(y : CGFloat){
        holderHeight.constant = originalHeight + y
        self.layoutIfNeeded()
    }
    
    func restoreHeight(){
        holderHeight.constant = originalHeight
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
