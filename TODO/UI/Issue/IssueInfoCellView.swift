import UIKit
import Foundation

final class IssueInfoCellView: UITableViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        descriptionTextView.roundedCorners(5)
        descriptionTextView.border(1, color: UIColor.borderColor.CGColor)
        statusView.roundedCorners(5)
    }
    
    func bind(issue: Issue) {
        idLabel.text = "#\(issue.id.value)"
        titleLabel.text = issue.info.title
        descriptionTextView.text = issue.info.desc.isEmpty ? "No description provided." : issue.info.desc
        descriptionTextView.textColor = issue.info.desc.isEmpty ? UIColor.lightGrayColor() : UIColor.blackColor()
        statusView.backgroundColor = issue.info.state == .Open ? UIColor.issueOpenColor : UIColor.issueClosedColor
        statusText.text = issue.info.state.rawValue.capitalizedString
        let status = issue.info.state == .Open ? "opened" : "closed"
        let dateText = issue.info.state.closedAt?.formattedString ?? issue.info.createdAt.formattedString
        dateLabel.text = "\(status) this issue at \(dateText)"
    }
    
}
