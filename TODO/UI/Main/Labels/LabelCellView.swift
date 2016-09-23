import UIKit

final class LabelCellView: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var issueCountLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toSuperview: newWindow)
        colorView.roundedCorners(5)
        colorView.border(1, color: UIColor.borderColor.cgColor)
    }
    
    func bind(_ label: Label, titleOnly: Bool = false) {
        self.titleLabel.text = label.id.value
        self.colorView.backgroundColor = UIColor(red: CGFloat(label.info.color.r) / 255, green: CGFloat(label.info.color.g) / 255, blue: CGFloat(label.info.color.b) / 255, alpha: 1)
        label.info.openIssuesCount.forEach {
            switch $0 {
            case 1: self.issueCountLabel.text = "1 open issue"
            default: self.issueCountLabel.text = "\($0) open issues"
            }
        }
        issueCountLabel.isHidden = titleOnly
    }
    
}
