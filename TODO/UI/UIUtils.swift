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
        return UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
    }
    
}
