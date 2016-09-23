import UIKit

final class MilestoneCellView: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dueLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var openCountLabel: UILabel!
    @IBOutlet weak var closedCountLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
        progressView.roundedCorners(5)
    }
    
    func bind(_ milestone: Milestone) {
        titleLabel.text = milestone.id.value
        dueLabel.text = milestone.info.dueOn?.formattedString ?? "No due date"
        openCountLabel.text = milestone.info.openIssuesCount.map { String($0) }
        closedCountLabel.text = milestone.info.closedIssuesCount.map { String($0) }
        completedLabel.text = "\(Int(milestone.progress * 100))%"
        progressView.progress = milestone.progress
    }

}
