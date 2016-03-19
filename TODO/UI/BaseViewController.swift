import UIKit
import RxSwift

class BaseViewController: UIViewController {

    var disposeBag: DisposeBag = DisposeBag()

}

class BaseTableViewController: UITableViewController {
    
    var disposeBag: DisposeBag = DisposeBag()

}
