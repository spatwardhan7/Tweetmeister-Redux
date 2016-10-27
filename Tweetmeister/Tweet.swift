//
//  Tweet.swift
//  Tweetmeister
//
//  Created by Patwardhan, Saurabh on 10/25/16.
//  Copyright © 2016 Saurabh Patwardhan. All rights reserved.
//

import UIKit
import SwiftyJSON

class Tweet: NSObject {
    var text : String?
    var timestamp : Date?
    var retweetCount : Int = 0
    var favoritesCount : Int = 0
    var tweetJSON : JSON?
    
    init(dictionary: NSDictionary) {
        self.tweetJSON = JSON(dictionary)
        
        text = tweetJSON?["text"].string
        retweetCount = (tweetJSON?["retweet_count"].int) ?? 0
        favoritesCount = (tweetJSON?["favourites_count"].int) ?? 0
        
        let timestampString = tweetJSON?["created_at"].string
    
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries{
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
