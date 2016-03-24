import UIKit
import RxSwift

final class AddMilestoneViewController: BaseViewController {
    
    private let viewModel: AddMilestoneViewModel = AddMilestoneViewModel()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var createNewButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [titleTextField, descriptionTextView].forEach {
            $0.roundedCorners(5)
            $0.border(1, color: UIColor.borderColor.CGColor)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        bind()
        subscribeEvent()
    }
    
    private func bind() {
        titleTextField.rx_text.bindTo(viewModel.title).addDisposableTo(disposeBag)
        descriptionTextView.rx_text.bindTo(viewModel.desc).addDisposableTo(disposeBag)
        datePicker.rx_date.bindTo(viewModel.dueOn).addDisposableTo(disposeBag)
        viewModel.title.asObservable().map { !$0.isEmpty }.bindTo(createNewButton.rx_enabled).addDisposableTo(disposeBag)
    }
    
    private func subscribeEvent() {
        createNewButton.rx_tap
            .subscribeNext { [weak self] _ in
                self?.dismissViewControllerAnimated(true, completion: self?.viewModel.submit)
            }
            .addDisposableTo(disposeBag)
        cancelButton.rx_tap
            .subscribeNext { [weak self] _ in self?.dismissViewControllerAnimated(true, completion: nil) }
            .addDisposableTo(disposeBag)
        tapGestureRecognizer.rx_event
            .subscribeNext { [weak self] _ in
                self?.titleTextField.resignFirstResponder()
                self?.descriptionTextView.resignFirstResponder()
            }
            .addDisposableTo(disposeBag)
    }
}
