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
    @IBOutlet weak var buttonHolderViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    let darkGray = UIColor(red: (101/255.0), green: (119/255.0), blue: (134/255.0), alpha: 1.0)
    
    let twitterBlack = UIColor(red: (20/255.0), green: (23/255.0), blue: (26/255.0), alpha: 1.0)
    
    let twitterBlue = UIColor(red: (29/255.0), green: (161/255.0), blue: (242/255.0), alpha: 1.0)
    
    let twitterExtraLightGray = UIColor(red: (225/255.0), green: (232/255.0), blue: (237/255.0), alpha: 1.0)
    
        let twitterRed = UIColor(red: (225/255.0), green: (35/255.0), blue: (83/255.0), alpha: 1.0)
    
    let placeholder = "What's happening?"
    
    var tweet : Tweet!
    
    let characterLimit = 140
    var isPlaceHolderShown : Bool = false
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
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
            characterCountLabel.text = "\(characterLimit - tweetTextView.text.characters.count)"
            setButtonEnabled()
        } else {
            setPlaceholder()
        }
        
    }
    
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            //let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.buttonHolderViewBottomConstraint?.constant = 0.0
            } else {
                self.buttonHolderViewBottomConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: animationCurve,
                           animations: {},
                           completion: nil)
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
        tweetButton.backgroundColor = twitterExtraLightGray
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
            isPlaceHolderShown = true
            textView.text = placeholder
            textView.textColor = darkGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            setButtonDisabled()
            characterCountLabel.text = "\(characterLimit)"
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to dar gray to prepare for
            // the user's entry
        else if textView.textColor == darkGray && !text.isEmpty {
            isPlaceHolderShown = false
            textView.text = nil
            textView.textColor = twitterBlack
            setButtonEnabled()
        }
        return true
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if(isPlaceHolderShown){
            characterCountLabel.text = "\(characterLimit)"
        }  else {
            let newCount = characterLimit - textView.text.characters.count
            if(newCount < 20){
                characterCountLabel.textColor = twitterRed
            } else {
                characterCountLabel.textColor = darkGray
            }
            if(newCount < 0){
                setButtonDisabled()
            } else {
                setButtonEnabled()
            }
            characterCountLabel.text = "\(newCount)"
        }
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
