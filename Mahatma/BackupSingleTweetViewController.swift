//
//  FirstViewController.swift
//  Mahatma
//
//  Created by Johan Cornelissen on 2018-02-02.
//  Copyright © 2018 Johan Cornelissen. All rights reserved.
//

import UIKit

class BackupSingleTweetViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                print("signed in as \(session?.userName)");
            } else {
                print("error woof: \(error?.localizedDescription)");
            }
        })
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
        
        // Get the current userID. This value should be managed by the developer but can be retrieved from the TWTRSessionStore.
        if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
            let client = TWTRAPIClient(userID: userID)
            // make requests with client
        }
        
        let client = TWTRAPIClient()
        client.loadTweets(withIDs: ["955473428726689797","20","134"]) { (tweets, error) -> Void in
            // handle the response or error
            for tweeter in tweets!
            {
                let tweetView = TWTRTweetView(tweet: tweeter, style: TWTRTweetViewStyle.regular)
                tweetView.showActionButtons = true
                tweetView.center = CGPoint(x: self.view.bounds.midX, y: tweetView.center.y);
                
                self.view.addSubview(tweetView)
                
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

