//
//  FirstViewController.swift
//  Mahatma
//
//  Created by Johan Cornelissen on 2018-02-02.
//  Copyright © 2018 Johan Cornelissen. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            self.loginPressed(session:session, error:error)
            
        })
        //logInButton.center = self.view.center
        let theHeight = view.frame.size.height //grabs the height of your view
        logInButton.frame = CGRect(x: 0, y: theHeight - 125 , width: self.view.frame.width, height: 40)
        
        self.view.addSubview(logInButton)
    }
    
    func loginPressed(session:TWTRSession? = nil, error:Error? = nil) {
        if (session != nil) {
            print("signed in as \(session?.userName)");
        } else {
            print("error woof: \(error?.localizedDescription)");
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
            performSegue(withIdentifier:"segueLoginPressed", sender:nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

