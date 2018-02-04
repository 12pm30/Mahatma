//
//  FirstViewController.swift
//  Mahatma
//
//  Created by Johan Cornelissen on 2018-02-02.
//  Copyright © 2018 Johan Cornelissen. All rights reserved.
//

import UIKit

class Colors {
    var gl:CAGradientLayer!
    
    init() {
        let colorTop = UIColor(red: 192.0 / 255.0, green: 38.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 35.0 / 255.0, green: 2.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0).cgColor
        
        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 1.0]
    }
}

class FirstViewController: UIViewController {
    
    let colors = Colors()
    
    func refresh() {
        view.backgroundColor = UIColor.clear
        var backgroundLayer = colors.gl
        backgroundLayer?.frame = view.frame
        view.layer.insertSublayer(backgroundLayer!, at: 0)
    }
    
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

