import UIKit
import Foundation

final class EditIssueViewController: BaseViewController {
    
    fileprivate lazy var viewModel: EditIssueViewModel = EditIssueViewModel()
    func setViewModel(_ viewModel: EditIssueViewModel) {
        self.viewModel = viewModel
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var selectLabelsButton: UIButton!
    @IBOutlet weak var submitButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var milestonePicker: UIPickerView!
    @IBOutlet weak var navTitleItem: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        milestonePicker.dataSource = self
        milestonePicker.delegate = self
        [titleTextField, descriptionTextView, selectLabelsButton].forEach { _ in
            //$0.roundedCorners(5)
            //$0.border(1, color: UIColor.borderColor.cgColor)
        }
        navTitleItem.title = viewModel.isNewIssue ? "Submit new issue" : "Edit issue"
        titleTextField.text = viewModel.title.value
        descriptionTextView.text = viewModel.desc.value
        viewModel.milestone.value.flatMap(viewModel.milestones.value.index).forEach {
            self.milestonePicker.selectRow($0 + 1, inComponent: 0, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
        subscribeEvents()
    }
    
    private func bind() {
        // ViewModel ~> View
        viewModel.submittable.bindTo(submitButton.rx.enabled).addDisposableTo(disposeBag)
        viewModel.milestones.asObservable().map { _ in () }.subscribe(onNext: milestonePicker.reloadAllComponents).addDisposableTo(disposeBag)
        
        // View ~> ViewModel
        titleTextField.rx.text.bindTo(viewModel.title).addDisposableTo(disposeBag)
        descriptionTextView.rx.text.bindTo(viewModel.desc).addDisposableTo(disposeBag)
    }
    
    private func subscribeEvents() {
        cancelButton.rx.tap.single()
            .subscribe(onNext: { [weak self] _ in self?.dismiss(animated: true, completion: nil) })
            .addDisposableTo(disposeBag)
        tapGestureRecognizer.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.titleTextField.resignFirstResponder()
                self?.descriptionTextView.resignFirstResponder()
            })
            .addDisposableTo(disposeBag)
        selectLabelsButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self.forEach {
                    let vc = UIStoryboard.selectLabelsViewController($0.viewModel.labels)
                    $0.present(vc, animated: true, completion: nil)
                }
            })
            .addDisposableTo(disposeBag)
        submitButton.rx.tap.single()
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.submit()
                self?.dismiss(animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)
    }
    
}

extension EditIssueViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.milestones.value.count + 1
    }
    
}

extension EditIssueViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.milestone.value = viewModel.milestones.value.safeIndex(row - 1)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let text = viewModel.milestones.value.safeIndex(row - 1)?.id.value ?? "Issue with no milestone"
        return NSAttributedString(string: text)
    }
    
}
