import UIKit
import RxSwift
import Foundation

final class LicensesViewController: BaseViewController {
    
    @IBOutlet weak var licensesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Licenses"
        licensesTextView.text = String(data: NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("LICENSES", ofType: nil)!)!, encoding: NSUTF8StringEncoding)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        licensesTextView.setContentOffset(CGPointZero, animated: false)
    }
    
}
