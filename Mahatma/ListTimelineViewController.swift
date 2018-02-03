import UIKit

class ListTimelineViewController: TWTRTimelineViewController, TWTRTimelineDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let client = TWTRAPIClient.withCurrentUser()
        self.dataSource = TWTRUserTimelineDataSource(screenName: "therock", apiClient: client)
        
    }
}
