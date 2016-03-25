import UIKit

final class IssueCellView: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var milestoneLabel: UILabel!
    
    func bind(issue: Issue) {
        titleLabel.text = issue.info.title
        dataLabel.text = "#3 opened on 27 Dec 2014"
        milestoneLabel.text = issue.info.milestone?.id.value
    }

}
