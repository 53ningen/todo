import UIKit
import RxSwift
import Foundation

class BaseViewController: UIViewController {

    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        disposeBag = DisposeBag()
    }

}

class BaseTableViewController: UITableViewController {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        disposeBag = DisposeBag()
    }

}
