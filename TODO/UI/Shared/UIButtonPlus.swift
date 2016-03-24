import UIKit

final class UIButtonPlus: UIButton {

    @IBInspectable var defaultBackgroundColor :UIColor?
    @IBInspectable var disabledBackgroundColor :UIColor?
    @IBInspectable var highlightedBackgroundColor :UIColor?
    
    override var enabled: Bool {
        didSet { backgroundColor = enabled ? defaultBackgroundColor : disabledBackgroundColor }
    }
    
    override var highlighted: Bool {
        didSet { backgroundColor = highlighted ? highlightedBackgroundColor : defaultBackgroundColor }
    }
    
}
