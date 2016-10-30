//
//  User.swift
//  Tweetmeister
//
//  Created by Patwardhan, Saurabh on 10/25/16.
//  Copyright © 2016 Saurabh Patwardhan. All rights reserved.
//

import UIKit
import SwiftyJSON

class User: NSObject {
    
    static let userDidLogoutNotification = "UserDidLogout"

    var name : String?
    var screenName : String?
    var profileUrl : URL?
    var tagline : String?
    var dictionary : NSDictionary?
    var userJSON : JSON?
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        self.userJSON = JSON(dictionary)
        
        name = userJSON?["name"].string
        screenName = userJSON?["screen_name"].string
        
        if let profileUrlString = userJSON?["profile_image_url_https"].string{
        profileUrl = URL(string : profileUrlString)
        }
        
        if let taglineString = userJSON?["description"].string{
            tagline = taglineString
        }
    }
    
    
    // _ hidden by convention
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil  {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? NSData
                
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try!  JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey : "currentUserData")
            } else {
                //defaults.set(nil, forKey : "currentUserData")
                defaults.removeObject(forKey: "currentUserData")
                
            }
            defaults.synchronize()
        }
    }
}
