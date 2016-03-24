import UIKit
import RxSwift
import Foundation

private struct SettingsViewItem {
    let indexPath: NSIndexPath
    static let Licenses = SettingsViewItem(indexPath: NSIndexPath(forItem: 0, inSection: 0))
}

final class SettingsViewController: BaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath {
        case SettingsViewItem.Licenses.indexPath:
            let vc = UIViewController.of(LicensesViewController.self)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
}
