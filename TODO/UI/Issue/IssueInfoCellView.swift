import UIKit
import Foundation

final class IssueInfoCellView: UITableViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        descriptionTextView.roundedCorners(5)
        descriptionTextView.border(1, color: UIColor.borderColor.CGColor)
    }
    
    func bind(issue: Issue) {
        idLabel.text = "#\(issue.id.value)"
        titleLabel.text = issue.info.title
        descriptionTextView.text = issue.info.desc.isEmpty ? "No description provided." : issue.info.desc
        descriptionTextView.textColor = issue.info.desc.isEmpty ? UIColor.lightGrayColor() : UIColor.blackColor()
    }
    
}
