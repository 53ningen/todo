import UIKit
import Foundation

final class IssueInfoCellView: UITableViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func bind(issue: Issue) {
        idLabel.text = "#\(issue.id.value)"
        titleLabel.text = issue.info.title
        descriptionLabel.text = issue.info.desc
    }
    
}
