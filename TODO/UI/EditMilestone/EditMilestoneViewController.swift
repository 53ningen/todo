import UIKit
import RxSwift

final class EditMilestoneViewController: BaseViewController {
    
    private let viewModel: EditMilestoneViewModel = EditMilestoneViewModel()
    
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
        titleTextField.text = viewModel.title.value
        descriptionTextView.text = viewModel.desc.value
        viewModel.dueOn.value.forEach { self.datePicker.date = $0 }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        bind()
        subscribeEvent()
    }
    
    private func bind() {
        // view ~> model
        titleTextField.rx_text.bindTo(viewModel.title).addDisposableTo(disposeBag)
        descriptionTextView.rx_text.bindTo(viewModel.desc).addDisposableTo(disposeBag)
        datePicker.rx_date.skip(1).map { $0 }.bindTo(viewModel.dueOn).addDisposableTo(disposeBag)
        
        // model ~> view
        viewModel.submittable.bindTo(createNewButton.rx_enabled).addDisposableTo(disposeBag)
    }
    
    private func subscribeEvent() {
        createNewButton.rx_tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.submit()
                self?.dismissViewControllerAnimated(true, completion: nil)
            })
            .addDisposableTo(disposeBag)
        cancelButton.rx_tap
            .subscribe(onNext: { [weak self] _ in self?.dismissViewControllerAnimated(true, completion: nil) })
            .addDisposableTo(disposeBag)
        tapGestureRecognizer.rx_event
            .subscribe(onNext: { [weak self] _ in
                self?.titleTextField.resignFirstResponder()
                self?.descriptionTextView.resignFirstResponder()
            })
            .addDisposableTo(disposeBag)
    }
}
