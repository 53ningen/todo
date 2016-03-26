import UIKit

final class LabelCellView: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var issueCountLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    override func willMoveToWindow(newWindow: UIWindow?) {
        super.willMoveToSuperview(newWindow)
        colorView.roundedCorners(5)
        colorView.border(1, color: UIColor.borderColor.CGColor)
    }
    
    func bind(label: Label, titleOnly: Bool = false) {
        self.titleLabel.text = label.id.value
        self.colorView.backgroundColor = UIColor(red: CGFloat(label.info.color.r) / 255, green: CGFloat(label.info.color.g) / 255, blue: CGFloat(label.info.color.b) / 255, alpha: 1)
        label.info.numberOfIssues.forEach {
            switch $0 {
            case 1: self.issueCountLabel.text = "1 open issue"
            default: self.issueCountLabel.text = "\($0) open issues"
            }
        }
        issueCountLabel.hidden = titleOnly
    }
    
}
