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
        colorView.border(1, color: UIColor.borderColor.CGColor)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        bind()
        subscribeEvents()
    }
    
    private func bind() {
        let obs = viewModel.color.asObservable().shareReplay(1)
        obs.map { Float($0.r) }.bindTo(rSlider.rx_value).addDisposableTo(disposeBag)
        obs.map { Float($0.g) }.bindTo(gSlider.rx_value).addDisposableTo(disposeBag)
        obs.map { Float($0.b) }.bindTo(bSlider.rx_value).addDisposableTo(disposeBag)
        obs.subscribeNext { [weak self] color in
            self?.colorView.backgroundColor = UIColor(red: CGFloat(color.r) / 255, green: CGFloat(color.g) / 255, blue: CGFloat(color.b) / 255, alpha: 1)
        }
        .addDisposableTo(disposeBag)
        nameTextField.rx_text.bindTo(viewModel.name).addDisposableTo(disposeBag)
        viewModel.submittable.bindTo(addButton.rx_enabled).addDisposableTo(disposeBag)
    }
    
    private func subscribeEvents() {
        addButton.rx_tap
            .subscribeNext { [weak self] _ in
                self?.viewModel.submit()
                self?.dismissViewControllerAnimated(true, completion: nil)
            }
            .addDisposableTo(disposeBag)
        rSlider.rx_value.subscribeNext { [weak self] r in self?.viewModel.nextColor(r, g: nil, b: nil) }.addDisposableTo(disposeBag)
        gSlider.rx_value.subscribeNext { [weak self] g in self?.viewModel.nextColor(nil, g: g, b: nil) }.addDisposableTo(disposeBag)
        bSlider.rx_value.subscribeNext { [weak self] b in self?.viewModel.nextColor(nil, g: nil, b: b) }.addDisposableTo(disposeBag)
        cancelButton.rx_tap.subscribeNext { [weak self] _ in self?.dismissViewControllerAnimated(true, completion: nil) }.addDisposableTo(disposeBag)
        tapGestureRecognizer.rx_event
            .subscribeNext { [weak self] _ in
                self?.nameTextField.resignFirstResponder()
            }
            .addDisposableTo(disposeBag)
        
    }
    
}
