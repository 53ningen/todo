import UIKit
import Foundation

final class HeaderCellView: UIView {
    
    @IBOutlet weak var headerLabel: UILabel!

    func bind(text: String) {
        headerLabel.text = text
    }
    
}
