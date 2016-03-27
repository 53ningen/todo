import UIKit
import RxSwift

extension UIStoryboard {
    
    static func selectLabelsViewController(selectedLabels: Variable<[Label]>) -> SelectLabelsViewController {
        let vc = UIViewController.of(SelectLabelsViewController.self)
        vc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        vc.setViewModel(SelectLabelsViewModel(selected: selectedLabels))
        return vc
    }
    
    static var issueViewController: IssueViewController {
        let vc = UIViewController.of(IssueViewController.self)
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
    
    static var addIssueViewController: AddIssueViewController {
        return UIViewController.of(AddIssueViewController.self)
    }
    
    static var addLabelViewController: AddLabelViewController {
        return UIViewController.of(AddLabelViewController.self)
    }
    
    static var addMilestoneViewController: AddMilestoneViewController {
        return UIViewController.of(AddMilestoneViewController.self)
    }
    
    static func issuesViewController(query: IssuesQuery) -> IssuesViewController {
        let vc = UIViewController.of(IssuesViewController.self)
        vc.setViewModel(IssuesViewModel(query: query))
        return vc
    }
    
    static var licenseViewController: LicensesViewController {
        let vc = UIViewController.of(LicensesViewController.self)
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
    
}
