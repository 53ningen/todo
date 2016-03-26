import UIKit

final class MilestoneCellView: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dueLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var openCountLabel: UILabel!
    @IBOutlet weak var closedCountLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        progressView.transform = CGAffineTransformMakeScale(1.0, 5.0)
        progressView.roundedCorners(5)
    }
    
    func bind(milestone: Milestone) {
        titleLabel.text = milestone.id.value
        dueLabel.text = milestone.info.dueOn?.formattedString ?? "No due date"
        openCountLabel.text = milestone.info.openIssuesCount.map { String($0) }
        closedCountLabel.text = milestone.info.closedIssuesCount.map { String($0) }
        completedLabel.text = "\(Int(milestone.progress * 100))%"
        progressView.progress = milestone.progress
    }

}
