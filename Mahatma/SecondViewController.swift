import UIKit
import TwitterKit
import Foundation

var screenNames = [String]()

class SecondViewController: UITableViewController , TWTRTweetViewDelegate {
    
    // setup a 'container' for Tweets
    var tweets: [TWTRTweet] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var prototypeCell: TWTRTweetTableViewCell?
    
    let tweetTableCellReuseIdentifier = "TweetCell"
    
    var isLoadingTweets = false
    
    let welcomeInstructionsVar = welcomeInstructions(text: "Oh no! You have no Mahatmas yet.", text2: "Add new Mahatmas in preferences tab.")
    
    var tweetIDs = [String]()
    
    lazy var refreshControlNew: UIRefreshControl = {
        let refreshControlNew = UIRefreshControl()
        refreshControlNew.addTarget(self, action: #selector(refreshTweets(notification:)), for: UIControlEvents.valueChanged)
        return refreshControlNew
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For gradient background
        //view.setGradientBackground(colorOne: Colors.lightestBlue, colorTwo: Colors.lightBlue)
        
        if(screenNames.count == 0){
            let defaults = UserDefaults.standard
            if let screenNamesBackup = defaults.array(forKey: defaultsKeys.keyOne) {
                screenNames = screenNamesBackup as! [String]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
                
                // Update tweet view (send message to other view controller)
                refreshTweetsInternal()
            }
        }
        
        // Create and add the view to the screen.
        let progressHUD = ProgressHUD(text: "Retrieving Tweets")
        progressHUD.tag = 100;
        progressHUD.center = self.view.center;
        self.view.addSubview(progressHUD)
        
        if(screenNames.count == 0){
            // Add the welcome instruction view to the screen.
            welcomeInstructionsVar.tag = 110;
            welcomeInstructionsVar.center = self.view.center;
            self.view.addSubview(welcomeInstructionsVar)
        }
        
        self.tableView.addSubview(self.refreshControlNew)
        
        NotificationCenter.default.addObserver(self, selector:#selector(refreshTweets(notification:)),name:NSNotification.Name(rawValue: "refreshTweets"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Make sure the navigation bar is not translucent when scrolling the table view.
        self.navigationController?.navigationBar.isTranslucent = false
        
        //refreshTweets()
    }
    
    @objc func refreshTweets(notification: NSNotification) {
        print("RefreshTweets from notification!")
        
        refreshTweetsInternal()
    }
    
    func refreshTweetsInternal() {
        // Get the current userID. This value should be managed by the developer but can be retrieved from the TWTRSessionStore.
        var counter = 0
        tweetIDs.removeAll()
        self.tweets.removeAll()
        
        // Get new tweet stream if atleast one user exists in Mahatmas list.
        if (screenNames.count != 0) {
            //Remove welcome message as there is now atleast one user.
            welcomeInstructionsVar.hide()
            
            var tweetCount = min(30,150/screenNames.count)
            for i in 0...screenNames.count-1 {
                if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
                    let client = TWTRAPIClient(userID: userID)
                    // make requests with client
                    let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
                    let params = ["screen_name": screenNames[i], "count": "\(tweetCount)"]
                    var clientError : NSError?
                    
                    let request = client.urlRequest(withMethod: "GET", urlString: statusesShowEndpoint, parameters: params, error: &clientError)
                    
                    client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                        if connectionError != nil {
                            print("Error: \(connectionError)")
                        }
                        
                        do {
                            if (data != nil) {
                                //Send message to update table with valid user.
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTableValid"), object: nil)
                                
                                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String:Any]]
                                //print("json: \(json)")
                                for item in json! {
                                    self.tweetIDs.append(String(format: "%@", item["id"] as! CVarArg))
                                }
                                counter = counter + 1
                                if (counter > screenNames.count-1) {
                                    self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
                                    
                                    // Create a single prototype cell for height calculations.
                                    self.prototypeCell = TWTRTweetTableViewCell(style: .default, reuseIdentifier: self.tweetTableCellReuseIdentifier)
                                    
                                    // Register the identifier for TWTRTweetTableViewCell.
                                    self.tableView.register(TWTRTweetTableViewCell.self, forCellReuseIdentifier: self.tweetTableCellReuseIdentifier)
                                    
                                    // Setup table data
                                    self.loadTweets()
                                    
                                }
                            }
                            else {
                                screenNames.popLast()
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
                            }
                            
                        } catch let jsonError as NSError {
                            print("json error: \(jsonError.localizedDescription)")
                        }
                    }
                }
            }
        } else {
            // Add the welcome instruction view to the screen (if no users exist).
            welcomeInstructionsVar.show()
        }
        refreshControlNew.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func loadTweets() {
        // Do not trigger another request if one is already in progress.
        if self.isLoadingTweets {
            return
        }
        self.isLoadingTweets = true
        
        // set tweetIds to find
        
        
        // Find the tweets with the tweetIDs
        let client = TWTRAPIClient()
        client.loadTweets(withIDs: tweetIDs) { (twttrs, error) -> Void in
            
            // If there are tweets do something magical
            if ((twttrs) != nil) {
                
                let sortedArray = twttrs?.sorted {$0.createdAt.timeIntervalSince1970 > $1.createdAt.timeIntervalSince1970}
                // Loop through tweets and do something
                for i in sortedArray! {
                    
                    print(i.createdAt.timeIntervalSince1970)
                    // Append the Tweet to the Tweets to display in the table view.
                    self.tweets.append(i as TWTRTweet)
                }
            } else {
                print(error as Any)
            }
        }
        self.isLoadingTweets = false
    }
    
    func refreshInvoked() {
        // Trigger a load for the most recent Tweets.
        loadTweets()
    }
    
    // MARK: TWTRTweetViewDelegate
    func tweetView(_ tweetView: TWTRTweetView!, didSelect tweet: TWTRTweet!) {
        // Display a Web View when selecting the Tweet.
        let webViewController = UIViewController()
        let webView = UIWebView(frame: webViewController.view.bounds)
        webView.loadRequest(URLRequest(url: tweet.permalink))
        webViewController.view = webView
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of Tweets.
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Retrieve the Tweet cell.
        let cell = tableView.dequeueReusableCell(withIdentifier: tweetTableCellReuseIdentifier, for: indexPath) as! TWTRTweetTableViewCell
        
        // Assign the delegate to control events on Tweets.
        cell.tweetView.delegate = self
        
        // Retrieve the Tweet model from loaded Tweets.
        let tweet = tweets[indexPath.row]
        
        // Configure the cell with the Tweet.
        cell.configure(with: tweet)
        
        //Remove loading icon
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
        
        // Return the Tweet cell.
        return cell
    }
    
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tweet = self.tweets[indexPath.row]
        self.prototypeCell?.configure(with: tweet)
        
        return TWTRTweetTableViewCell.height(for: tweet, style: TWTRTweetViewStyle.compact, width: self.view.bounds.width, showingActions: false)
    }
}
