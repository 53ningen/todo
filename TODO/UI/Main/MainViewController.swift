import UIKit

final class MainViewController: BaseViewController {

    @IBOutlet weak var mainTabBar: UITabBar!
    @IBOutlet weak var issuesItem: UITabBarItem!
    @IBOutlet weak var labelsItem: UITabBarItem!
    @IBOutlet weak var milestonesItem: UITabBarItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTabBar.delegate = self
        mainTabBar.selectedItem = issuesItem
    }

}

extension MainViewController: UITabBarDelegate {

    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        NSLog("\(item.tag)")
    }
    
}
