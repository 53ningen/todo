import UIKit
import RxSwift

extension UIStoryboard {
    
    static func selectLabelsViewController(selectedLabels: Variable<[Label]>) -> SelectLabelsViewController {
        let vc = UIViewController.of(SelectLabelsViewController.self)
        vc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        vc.setViewModel(SelectLabelsViewModel(selected: selectedLabels))
        return vc
    }
    
    static func issueViewController(id: Id<Issue>) -> IssueViewController {
        let vc = UIViewController.of(IssueViewController.self)
        vc.setViewModel(IssueViewModel(id: id))
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
    
    static func editIssueViewController(issue: Issue? = nil) -> EditIssueViewController {
        let vc = UIViewController.of(EditIssueViewController.self)
        issue.forEach { vc.setViewModel(EditIssueViewModel(issue: $0)) }
        return vc
    }
    
    static var addLabelViewController: AddLabelViewController {
        return UIViewController.of(AddLabelViewController.self)
    }
    
    static var addMilestoneViewController: EditMilestoneViewController {
        return UIViewController.of(EditMilestoneViewController.self)
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
