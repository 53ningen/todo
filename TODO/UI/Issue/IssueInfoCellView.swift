import UIKit
import Foundation

final class IssueInfoCellView: UITableViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        descriptionTextView.roundedCorners(5)
        descriptionTextView.border(1, color: UIColor.borderColor.cgColor)
        statusView.roundedCorners(5)
    }
    
    func bind(_ issue: Issue) {
        idLabel.text = "#\(issue.id.value)"
        titleLabel.text = issue.info.title
        descriptionTextView.text = issue.info.desc.isEmpty ? "No description provided." : issue.info.desc
        descriptionTextView.textColor = issue.info.desc.isEmpty ? UIColor.lightGray : UIColor.black
        statusView.backgroundColor = issue.info.state == .open ? UIColor.issueOpenColor : UIColor.issueClosedColor
        statusText.text = issue.info.state.rawValue.capitalized
        let status = issue.info.state == .open ? "opened" : "closed"
        let dateText = issue.info.state.closedAt?.formattedString ?? issue.info.createdAt.formattedString
        dateLabel.text = "\(status) this issue on \(dateText)"
    }
    
}
