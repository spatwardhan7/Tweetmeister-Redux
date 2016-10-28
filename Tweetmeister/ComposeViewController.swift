//
//  ComposeViewController.swift
//  Tweetmeister
//
//  Created by Patwardhan, Saurabh on 10/27/16.
//  Copyright © 2016 Saurabh Patwardhan. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var tweetButton: UIButton!
    
    let darkGray = UIColor(red: (101/255.0), green: (119/255.0), blue: (134/255.0), alpha: 1.0)
    
    let twitterBlack = UIColor(red: (20/255.0), green: (23/255.0), blue: (26/255.0), alpha: 1.0)
    
    let twitterBlue = UIColor(red: (29/255.0), green: (161/255.0), blue: (242/255.0), alpha: 1.0)
    
    let placeholder = "What's happening?"
    
    var tweet : Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        StaticHelper.fadeInImage(posterImageView: profileImageView, posterImageUrl: (User.currentUser?.profileUrl)!)
        
        setupTweetButton()
        setupTextView()

        if(tweet != nil){
            var mentionsString = tweet.username
            var tempStr : String = ""
            var temp2Str : String = ""
            if(tweet.userMentions != nil) {
                let mentions = tweet.userMentions as? [[String : Any]]
                for mention in mentions!{
                    temp2Str = mention["screen_name"] as! String
                    tempStr += " @" + temp2Str
                }
                mentionsString += tempStr
            }
            tweetTextView.textColor = twitterBlack
            tweetTextView.text = mentionsString + " "
            setButtonEnabled()
        } else {
            setPlaceholder()
        }
        
    }
    
    func setupTweetButton(){
        tweetButton.layer.cornerRadius = 5
        tweetButton.layer.borderWidth = 1
        tweetButton.isEnabled = false
        
        tweetButton.layer.borderColor = darkGray.cgColor
        tweetButton.setTitleColor(darkGray, for: UIControlState.disabled)
        tweetButton.setTitleColor(UIColor.white, for: UIControlState.normal)
    }
    
    func setupTextView(){
        tweetTextView.delegate = self
        tweetTextView.autocapitalizationType = UITextAutocapitalizationType.sentences
        tweetTextView.becomeFirstResponder()
    }
    
    func setPlaceholder(){
        let startPosition : UITextPosition = tweetTextView.beginningOfDocument
        tweetTextView.text = placeholder
        tweetTextView.textColor =  darkGray// Dark Gray
        tweetTextView.selectedTextRange = tweetTextView.textRange(from: startPosition, to: startPosition)
    }
    
    func setButtonDisabled(){
        tweetButton.layer.borderWidth = 1
        tweetButton.backgroundColor = self.view.backgroundColor
        tweetButton.isEnabled = false
    }
    
    func setButtonEnabled(){
        tweetButton.layer.borderWidth = 0
        tweetButton.backgroundColor = twitterBlue
        tweetButton.isEnabled = true
        
    }
    

    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText =  textView.text as NSString
        let updatedText = currentText.replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            textView.text = placeholder
            textView.textColor = darkGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            setButtonDisabled()
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to dar gray to prepare for
            // the user's entry
        else if textView.textColor == darkGray && !text.isEmpty {
            textView.text = nil
            textView.textColor = twitterBlack
            setButtonEnabled()
        }
        
        return true
        
    }
    @IBAction func onTweetButton(_ sender: AnyObject) {
        //let encodedStatus = tweetTextView.text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        var params = [String : String]()
        params["status"] = tweetTextView.text
        
        TwitterClient.sharedInstance?.postTweet(params: params, success: {
            print("--- Compose Tweet Success")
            self.dismiss(animated: true, completion: nil)
            }, failure: { (error : Error) in
                print("--- Compose Tweet Failure: \(error.localizedDescription)")
        })
        
        
    }
    
    @IBAction func onCancelButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
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
