import UIKit
import Foundation

final class AddIssueViewController: BaseViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var selectLabelsButton: UIButton!
    @IBOutlet weak var selectMilestoneButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [descriptionTextView, selectMilestoneButton, selectLabelsButton, submitButton].forEach {
            $0.roundedCorners(5)
            $0.border(1, color: UIColor.borderColor.CGColor)
        }
        cancelButton.rx_tap.single()
            .subscribeNext { _ in self.dismissViewControllerAnimated(true, completion: nil) }
            .addDisposableTo(disposeBag)
        tapGestureRecognizer.rx_event
            .subscribeNext { _ in
                self.titleTextField.resignFirstResponder()
                self.descriptionTextView.resignFirstResponder()
            }
            .addDisposableTo(disposeBag)
    }
    
}
