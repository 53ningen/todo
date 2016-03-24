import UIKit
import RxSwift

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
