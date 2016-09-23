import UIKit
import RxSwift
import Foundation

private struct SettingsViewItem {
    let indexPath: IndexPath
    static let DeleteAllData = SettingsViewItem(indexPath: IndexPath(item: 0, section: 0))
    static let Licenses = SettingsViewItem(indexPath: IndexPath(item: 0, section: 1))
}

final class SettingsViewController: BaseTableViewController {
    
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        versionLabel.text = AppModules.applicationSettings.bundleShortVersionString
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath {
        case SettingsViewItem.DeleteAllData.indexPath:
            let alert = UIAlertController(title: "Delete All Data", message: "Once you delete data, there is no going back. Please be certain.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in RealmOperator.deleteAll() })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        case SettingsViewItem.Licenses.indexPath:
            navigationController?.pushViewController(UIStoryboard.licenseViewController, animated: true)
        default:
            break
        }
    }
    
}
