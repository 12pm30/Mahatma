//
//  searchViewController.swift
//  Mahatma
//
//  Created by Johan Cornelissen on 2018-02-03.
//  Copyright © 2018 Johan Cornelissen. All rights reserved.
//

import Foundation

struct defaultsKeys {
    static let keyOne = "screenNamesKeys"
    static let keyTwo = "stringKey"
}

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchActive : Bool = false
    
    @objc override func viewDidLoad() {
        super.viewDidLoad()
        
        // For gradient background
        //view.setGradientBackground(colorOne: Colors.lightestBlue, colorTwo: Colors.lightBlue)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        searchBar.autocapitalizationType = UITextAutocapitalizationType.none
        
        NotificationCenter.default.addObserver(self, selector:#selector(refreshTableAfterInvalidName(notification:)),name:NSNotification.Name(rawValue: "reloadTable"), object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(refreshTableAfterValidName(notification:)),name:NSNotification.Name(rawValue: "reloadTableValid"), object: nil)
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    /* Responds to Every key press */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func refreshTableAfterInvalidName(notification: NSNotification) {
        tableView.reloadData()
        
        let alert = UIAlertController(title: "Alert", message: "Twitter User provided is invalid.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func refreshTableAfterValidName(notification: NSNotification) {
        // Update the persistent data (after adding a new valid name)
        let defaults = UserDefaults.standard
        defaults.set(screenNames, forKey: defaultsKeys.keyOne)
        
        tableView.reloadData()
    }
    
    /* on search button press */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        screenNames.append(searchBar.text!)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshTweets"), object: nil)
        searchBar.text = ""
    }

    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenNames.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let alert = UIAlertController(title: "CONFIRM", message: "Are you sure you want to delete this user?", preferredStyle: UIAlertControllerStyle.alert)
            let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.default) {
                UIAlertAction in

                // Delete from screenNames and the table of valid Mahatma's
                screenNames.remove(at: indexPath.row)
                tableView.reloadData()
                
                // Delete tweets from now removed user. (send message to other view controller)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshTweets"), object: nil)
                
                // Update the persistent data
                let defaults = UserDefaults.standard
                defaults.set(screenNames, forKey: defaultsKeys.keyOne)
            }
            alert.addAction(deleteAction)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /* To wrap around dequeue some */
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UITableViewCell;
        cell.textLabel?.text = screenNames[indexPath.row] //filtered[filtered.count];
        
        return cell;
    }

}
