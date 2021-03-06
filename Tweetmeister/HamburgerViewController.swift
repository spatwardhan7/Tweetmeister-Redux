//
//  HamburgerViewController.swift
//  Tweetmeister
//
//  Created by Patwardhan, Saurabh on 11/3/16.
//  Copyright © 2016 Saurabh Patwardhan. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    
    var originalLeftMargin : CGFloat!
    
    var menuViewController : UIViewController! {
        didSet{
            view.layoutIfNeeded()
            menuView.addSubview(menuViewController.view)
        }
    }
    
    var contentViewController : UIViewController! {
        didSet {
            if (oldValue != nil) {
                oldValue.willMove(toParentViewController: nil)
                oldValue.view.removeFromSuperview()
                oldValue.removeFromParentViewController()
            }
            self.addChildViewController(contentViewController)
            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            
            UIView.animate(withDuration: 0.3) {
                self.leftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == UIGestureRecognizerState.began{
            originalLeftMargin = leftMarginConstraint.constant
        } else if sender.state == UIGestureRecognizerState.changed{
            if velocity.x > 0 {
                leftMarginConstraint.constant = originalLeftMargin + translation.x
            }
            
            if velocity.y > 0 {
            }
            
        } else if sender.state == UIGestureRecognizerState.ended{
           
            UIView.animate(withDuration: 0.3, animations: {
                // opening
                if velocity.x > 0 {
                    self.leftMarginConstraint.constant = self.view.frame.size.width - 50
                    self.contentView.subviews[0].isUserInteractionEnabled = false
                } else {
                    // closing
                    self.leftMarginConstraint.constant = 0
                    self.contentView.subviews[0].isUserInteractionEnabled = true
                }
                self.view.layoutIfNeeded()
            })
            
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
