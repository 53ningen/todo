import UIKit

final class LabelCellView: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var issueCountLabel: UILabel!
    
    func bind(label: Label) {
        self.titleLabel.text = label.id.value
    }
    
}
