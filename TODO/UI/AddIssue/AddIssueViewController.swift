import UIKit
import Foundation

final class AddIssueViewController: BaseViewController {
    
    private let viewModel: AddIssueViewModel = AddIssueViewModel()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var selectLabelsButton: UIButton!
    @IBOutlet weak var selectMilestoneButton: UIButton!
    @IBOutlet weak var submitButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // View の 初期化
        [titleTextField, descriptionTextView, selectMilestoneButton, selectLabelsButton].forEach {
            $0.roundedCorners(5)
            $0.border(1, color: UIColor.borderColor.CGColor)
        }
        bind()
        subscribeEvents()
    }
    
    private func subscribeEvents() {
        cancelButton.rx_tap.single()
            .subscribeNext { [weak self] _ in self?.dismissViewControllerAnimated(true, completion: nil) }
            .addDisposableTo(disposeBag)
        tapGestureRecognizer.rx_event
            .subscribeNext { [weak self] _ in
                self?.titleTextField.resignFirstResponder()
                self?.descriptionTextView.resignFirstResponder()
            }
            .addDisposableTo(disposeBag)
        submitButton.rx_tap.single()
            .subscribeNext { [weak self] _ in self?.dismissViewControllerAnimated(true, completion: self?.viewModel.submit) }
            .addDisposableTo(disposeBag)
    }
    
    private func bind() {
        // View ~> ViewModel
        titleTextField.rx_text.bindTo(viewModel.title).addDisposableTo(disposeBag)
        descriptionTextView.rx_text.bindTo(viewModel.desc).addDisposableTo(disposeBag)
        
        // ViewModel ~> View
        viewModel.submittable.bindTo(submitButton.rx_enabled).addDisposableTo(disposeBag)
    }
    
}