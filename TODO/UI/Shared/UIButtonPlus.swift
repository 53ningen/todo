import UIKit

final class UIButtonPlus: UIButton {

    @IBInspectable var defaultBackgroundColor :UIColor?
    @IBInspectable var disabledBackgroundColor :UIColor?
    @IBInspectable var highlightedBackgroundColor :UIColor?
    
    override var isEnabled: Bool {
        didSet { backgroundColor = isEnabled ? defaultBackgroundColor : disabledBackgroundColor }
    }
    
    override var isHighlighted: Bool {
        didSet { backgroundColor = isHighlighted ? highlightedBackgroundColor : defaultBackgroundColor }
    }
    
}
