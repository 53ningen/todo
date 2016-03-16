import UIKit

final class IssueCellView: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var milestoneLabel: UILabel!
    @IBOutlet weak var issueIconButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    
    func bind(issue: Issue) {
        titleLabel.text = issue.info.title
        dataLabel.text = ""
        milestoneLabel.text = issue.info.milestone?.info.title
        issueIconButton.enabled = !issue.closed
    }

}
