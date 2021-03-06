import UIKit
import RxSwift

extension UIStoryboard {
    
    static func selectLabelsViewController(_ selectedLabels: Variable<[Label]>) -> SelectLabelsViewController {
        let vc = UIViewController.of(SelectLabelsViewController.self)
        vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        vc.setViewModel(SelectLabelsViewModel(selected: selectedLabels))
        return vc
    }
    
    static func issueViewController(_ id: Id<Issue>) -> IssueViewController {
        let vc = UIViewController.of(IssueViewController.self)
        vc.setViewModel(IssueViewModel(id: id))
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
    
    static func editIssueViewController(_ issue: Issue? = nil) -> EditIssueViewController {
        let vc = UIViewController.of(EditIssueViewController.self)
        issue.forEach { vc.setViewModel(EditIssueViewModel(issue: $0)) }
        return vc
    }
    
    static var addLabelViewController: EditLabelViewController {
        return UIViewController.of(EditLabelViewController.self)
    }
    
    static var addMilestoneViewController: EditMilestoneViewController {
        return UIViewController.of(EditMilestoneViewController.self)
    }
    
    static func issuesViewController(_ query: IssuesQuery) -> IssuesViewController {
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
