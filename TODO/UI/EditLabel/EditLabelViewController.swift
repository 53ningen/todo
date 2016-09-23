import UIKit
import RxSwift
import Foundation

final class EditLabelViewController: BaseViewController {

    private let viewModel: EditLabelViewModel = EditLabelViewModel()
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var rSlider: UISlider!
    @IBOutlet weak var gSlider: UISlider!
    @IBOutlet weak var bSlider: UISlider!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorView.roundedCorners(5)
        colorView.border(1, color: UIColor.borderColor.cgColor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
        subscribeEvents()
    }
    
    private func bind() {
        let obs = viewModel.color.asObservable().shareReplay(1)
        obs.map { Float($0.r) }.bindTo(rSlider.rx.value).addDisposableTo(disposeBag)
        obs.map { Float($0.g) }.bindTo(gSlider.rx.value).addDisposableTo(disposeBag)
        obs.map { Float($0.b) }.bindTo(bSlider.rx.value).addDisposableTo(disposeBag)
        obs.subscribe(onNext: { [weak self] color in
            self?.colorView.backgroundColor = UIColor(red: CGFloat(color.r) / 255, green: CGFloat(color.g) / 255, blue: CGFloat(color.b) / 255, alpha: 1)
        })
        .addDisposableTo(disposeBag)
        nameTextField.rx.text.bindTo(viewModel.name).addDisposableTo(disposeBag)
        viewModel.submittable.bindTo(addButton.rx.enabled).addDisposableTo(disposeBag)
    }
    
    private func subscribeEvents() {
        addButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.submit()
                self?.dismiss(animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)
        rSlider.rx.value.subscribe(onNext: { [weak self] r in self?.viewModel.nextColor(r, g: nil, b: nil) }).addDisposableTo(disposeBag)
        gSlider.rx.value.subscribe(onNext: { [weak self] g in self?.viewModel.nextColor(nil, g: g, b: nil) }).addDisposableTo(disposeBag)
        bSlider.rx.value.subscribe(onNext: { [weak self] b in self?.viewModel.nextColor(nil, g: nil, b: b) }).addDisposableTo(disposeBag)
        cancelButton.rx.tap.subscribe(onNext: { [weak self] _ in self?.dismiss(animated: true, completion: nil) }).addDisposableTo(disposeBag)
        tapGestureRecognizer.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.nameTextField.resignFirstResponder()
            })
            .addDisposableTo(disposeBag)
        
    }
    
}
