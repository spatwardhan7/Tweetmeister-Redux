//
//  TwitterClient.swift
//  Tweetmeister
//
//  Created by Patwardhan, Saurabh on 10/25/16.
//  Copyright © 2016 Saurabh Patwardhan. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import SwiftyJSON

class TwitterClient: BDBOAuth1SessionManager {
    
    
    static let sharedInstance = TwitterClient(baseURL : URL(string: "https://api.twitter.com")!,
                                              consumerKey: "OG97Dv5gaqvQG7cHs068NJ19G",
                                              consumerSecret: "Zvid40WID75Dr21UoZe6JfJDD12EvZfBKMEhZNQJV0sQB3uRAh")
    
    /* Secondary App in case of emergency
    static let sharedInstance = TwitterClient(baseURL : URL(string: "https://api.twitter.com")!,
                                              consumerKey: "mZeAHcBI5hezYEoHcvxbb4osj",
                                              consumerSecret: "NUDMoX6AHRxckNbsDNnwvNQyrWmNakjV0SFvBXMcq4DA43TGjs")
    */
    
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?

    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()){
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task : URLSessionDataTask, response : Any?) in
            print("--- TwitterClient: currentAccount : Success")
            let userDictionary = response as! NSDictionary
            let user = User(dictionary : userDictionary)
            
            success(user)
            
            }, failure: { (task : URLSessionDataTask?, error : Error) in
                failure(error)
        })
        
    }
    
    func postTweet(params: Any, success: @escaping() -> (), failure: @escaping (Error) -> ()){
        post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task : URLSessionDataTask,response : Any?) in
            success()
        }) { (task : URLSessionDataTask?,error: Error) in
                failure(error)
        }
    }
    
    func favoriteTweet(params: Any, success: @escaping() -> (), failure: @escaping (Error) -> ()){
        post("1.1/favorites/create.json", parameters: params, progress: nil, success: { (task : URLSessionDataTask,response : Any?) in
            success()
        }) { (task : URLSessionDataTask?,error: Error) in
            failure(error)
        }
    }
    
    func unfavoriteTweet(params: Any, success: @escaping() -> (), failure: @escaping (Error) -> ()){
        post("1.1/favorites/destroy.json", parameters: params, progress: nil, success: { (task : URLSessionDataTask,response : Any?) in
            success()
        }) { (task : URLSessionDataTask?,error: Error) in
            failure(error)
        }
    }
    
    /* showStatus has to be called before calling unretweet to get
     * the correct retweed id in case a tweet has been retweeted by
     * a bunch of people
     */
    func showStatuses(params: String, success: @escaping(NSDictionary) -> (), failure: @escaping (Error) -> ()){
        let showStatusesBaseUrl = "1.1/statuses/show/{id}.json?include_my_retweet=1"
        let showStatusUrl = showStatusesBaseUrl.replacingOccurrences(of: "{id}", with: params)
        get(showStatusUrl, parameters: nil, progress: nil, success: { (task : URLSessionDataTask,response : Any?) in
            let tweet = response as! NSDictionary
            success(tweet)
        }) { (task : URLSessionDataTask?,error: Error) in
            failure(error)
        }
    }
    
    func retweet(params: String, success: @escaping() -> (), failure: @escaping (Error) -> ()){
        let retweetBaseUrl = "1.1/statuses/retweet/{id}.json"
        let retweetUrl = retweetBaseUrl.replacingOccurrences(of: "{id}", with: params)
        post(retweetUrl, parameters: nil, progress: nil, success: { (task : URLSessionDataTask,response : Any?) in
            success()
        }) { (task : URLSessionDataTask?,error: Error) in
            failure(error)
        }
    }
    
    func unRetweet(params: String, success: @escaping() -> (), failure: @escaping (Error) -> ()){
        let unretweetBaseUrl = "1.1/statuses/unretweet/{id}.json"
        let unretweetUrl = unretweetBaseUrl.replacingOccurrences(of: "{id}", with: params)
        post(unretweetUrl, parameters: nil, progress: nil, success: { (task : URLSessionDataTask,response : Any?) in
            success()
        }) { (task : URLSessionDataTask?,error: Error) in
            failure(error)
        }
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()){
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task : URLSessionDataTask,response: Any?) in
            print("--- TwitterClient : home time line response  success")
            
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
            }, failure: { (task : URLSessionDataTask?, error : Error) in
                failure(error)
                
        })
    }
    
    func handleOpenUrl(url: URL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            if(accessToken != nil){
                print("--- TwitterClient : handle Open url :  got access token")
                
                let saveToken : Bool = (TwitterClient.sharedInstance?.requestSerializer.saveAccessToken(accessToken))!
                print("--- TwitterClinet : Save token result : \(saveToken)")
                
                self.currentAccount(success: { (user : User) -> () in
                    User.currentUser = user
                    self.loginSuccess?()
                    }, failure: { (error : Error) -> () in
                        self.loginFailure?(error)

                })
            }
            }, failure: { (error: Error?) in
                print("--- TwitterClient : handle Open url : failed to get access token: \(error?.localizedDescription)")
                self.loginFailure?(error!)
        })
    }
    
    func logout(){
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    func login(success: @escaping () -> () ,failure: @escaping (Error) -> ()){
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "Tweetmeister://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            // code print token
            if(requestToken != nil && requestToken?.token != nil){
                print("--- TwitterClient : login : got token")
                print("--- TwitterClient : login : request token : \(requestToken!)")
                print("--- TwitterClient : login : token: \(requestToken!.token!)")
                
                let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
                print("---- TwitterClient : login : url: \(url)")
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            }
            else {
                print("---- TwitterClient : login : token nil")
            }
            
            }, failure: { (error : Error?) -> Void in
                self.loginFailure?(error!)
        })
    }
}
