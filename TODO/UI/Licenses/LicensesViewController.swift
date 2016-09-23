import UIKit
import RxSwift
import Foundation

final class LicensesViewController: BaseViewController {
    
    @IBOutlet weak var licensesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Licenses"
        licensesTextView.text = String(data: try! Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "LICENSES", ofType: nil)!)), encoding: String.Encoding.utf8)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        licensesTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
}
