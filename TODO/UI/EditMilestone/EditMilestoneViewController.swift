import UIKit
import RxSwift

final class EditMilestoneViewController: BaseViewController {
    
    fileprivate let viewModel: EditMilestoneViewModel = EditMilestoneViewModel()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var createNewButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [titleTextField, descriptionTextView].forEach { _ in
            //($0 as AnyObject).roundedCorners(5)
            //($0 as AnyObject).border(1, color: UIColor.borderColor.cgColor)
        }
        titleTextField.text = viewModel.title.value
        descriptionTextView.text = viewModel.desc.value
        viewModel.dueOn.value.forEach { self.datePicker.date = $0 }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
        subscribeEvent()
    }
    
    private func bind() {
        // view ~> model
        titleTextField.rx.text.bindTo(viewModel.title).addDisposableTo(disposeBag)
        descriptionTextView.rx.text.bindTo(viewModel.desc).addDisposableTo(disposeBag)
        datePicker.rx.date.skip(1).map { $0 }.bindTo(viewModel.dueOn).addDisposableTo(disposeBag)
        
        // model ~> view
        viewModel.submittable.bindTo(createNewButton.rx.enabled).addDisposableTo(disposeBag)
    }
    
    private func subscribeEvent() {
        createNewButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.submit()
                self?.dismiss(animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.dismiss(animated: true, completion: nil) })
            .addDisposableTo(disposeBag)
        tapGestureRecognizer.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.titleTextField.resignFirstResponder()
                self?.descriptionTextView.resignFirstResponder()
            })
            .addDisposableTo(disposeBag)
    }
}
