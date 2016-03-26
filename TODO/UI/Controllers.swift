import UIKit
import RxSwift

struct Controllers {
    
    private init() {}
    
    static func selectLabelsViewController(selectedLabels: Variable<[Label]>) -> SelectLabelsViewController {
        let vc = UIViewController.of(SelectLabelsViewController.self)
        vc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        vc.setViewModel(SelectLabelsViewModel(selected: selectedLabels))
        return vc
    }
        
}
