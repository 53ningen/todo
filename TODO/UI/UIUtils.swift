/// UI層で用いるユーティリティーメソッド

import UIKit
import Foundation

extension NSObject {
    
    static func getClassName() -> String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last! as String
    }

    func getClassName() -> String {
        return NSStringFromClass(self.dynamicType).componentsSeparatedByString(".").last! as String
    }
    
}

extension UIView {
    
    static func getUINib() -> UINib {
        return UINib(nibName: getClassName(), bundle: NSBundle.mainBundle())
    }
    
    static func getInstance<T: UIView>(t: T.Type) -> T? {
        return T.getUINib().instantiateWithOwner(nil, options: nil).first as? T
    }
    
    func roundedCorners(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
    
    func border(width: CGFloat, color: CGColor) {
        layer.borderWidth = width
        layer.borderColor = color
    }
    
}

extension UITableViewCell {
    
    static var cellReuseIdentifier: String {
        return self.getClassName()
    }
    
}

extension UITableView {
    
    func registerNib(cls: UITableViewCell.Type) {
        registerNib(cls.getUINib(), forCellReuseIdentifier: cls.cellReuseIdentifier)
    }
    
}

extension UIViewController {
    
    static func of<T: UIViewController>(cls: T.Type) -> T {
        return UIStoryboard(name: cls.getClassName(), bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(cls.getClassName()) as! T
    }
    
}

extension UIColor {
    
    static var borderColor: UIColor {
        return UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1)
    }
    
    static var themeColor: UIColor {
        return UIColor(red: 96/255, green: 94/255, blue: 86/255, alpha: 1)
    }
    
    static var themeColorHighlighted: UIColor {
        return UIColor(red: 76/255, green: 74/255, blue: 66/255, alpha: 1)
    }
    
}
