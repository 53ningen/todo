import UIKit
import RxSwift
import Foundation

private struct SettingsViewItem {
    let indexPath: NSIndexPath
    static let DeleteAllData = SettingsViewItem(indexPath: NSIndexPath(forItem: 0, inSection: 0))
    static let Licenses = SettingsViewItem(indexPath: NSIndexPath(forItem: 0, inSection: 1))
}

final class SettingsViewController: BaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath {
        case SettingsViewItem.DeleteAllData.indexPath:
            let alert = UIAlertController(title: "Delete All Data", message: "Once you delete data, there is no going back. Please be certain.", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: { _ in RealmOperator.deleteAll() })
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alert.addAction(cancel)
            alert.addAction(ok)
            presentViewController(alert, animated: true, completion: nil)
        case SettingsViewItem.Licenses.indexPath:
            let vc = UIViewController.of(LicensesViewController.self)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
}
