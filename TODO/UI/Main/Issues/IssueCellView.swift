import UIKit

final class IssueCellView: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var milestoneLabel: UILabel!
    
    func bind(issue: Issue) {
        titleLabel.text = issue.info.title
        dataLabel.text = "#\(issue.id.value) opened on \(issue.info.createdAt.formattedString)"
        milestoneLabel.text = issue.info.milestone?.id.value
    }

}
