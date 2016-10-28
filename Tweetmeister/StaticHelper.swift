//
//  FadeInImage.swift
//  Tweetmeister
//
//  Created by Patwardhan, Saurabh on 10/27/16.
//  Copyright © 2016 Saurabh Patwardhan. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking

class StaticHelper{
    
    static func fadeInImage(posterImageView : UIImageView, posterImageUrl : URL){
        
        let imageUrlRequest = URLRequest(url: posterImageUrl)
        
        posterImageView.setImageWith(imageUrlRequest, placeholderImage: nil,
                                     success: { (request : URLRequest, response : HTTPURLResponse?, image : UIImage!) in
                                        if image != nil {
                                            posterImageView.alpha = 0
                                            posterImageView.image = image
                                            UIView.animate(withDuration: 0.5 , animations: {() -> Void in
                                                posterImageView.alpha = 1
                                            })
                                        }
                                        
            }, failure: { (request : URLRequest,response : HTTPURLResponse?,error : Error) -> Void in
                //self.posterImageView.image =
        })
        
    }
}
