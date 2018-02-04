//
//  searchViewController.swift
//  Mahatma
//
//  Created by Johan Cornelissen on 2018-02-03.
//  Copyright © 2018 Johan Cornelissen. All rights reserved.
//

import Foundation

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchActive : Bool = false
    
    @objc override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        searchBar.autocapitalizationType = UITextAutocapitalizationType.none
        
        NotificationCenter.default.addObserver(self, selector:#selector(refreshTableAfterInvalidName(notification:)),name:NSNotification.Name(rawValue: "reloadTable"), object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(refreshTableAfterValidName(notification:)),name:NSNotification.Name(rawValue: "reloadTableValid"), object: nil)
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    /* Every key press */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        /*
        filtered = data.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        */
        //print(searchText)
        //self.tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /* To wrap around dequeue some */
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UITableViewCell;
        cell.textLabel?.text = screenNames[indexPath.row] //filtered[filtered.count];
        
        return cell;
    }

}
