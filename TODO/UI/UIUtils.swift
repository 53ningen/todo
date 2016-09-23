/// UI層で用いるユーティリティーメソッド

import UIKit
import Foundation

extension NSObject {
    
    static func getClassName() -> String {
        return NSStringFromClass(self).components(separatedBy: ".").last! as String
    }

    func getClassName() -> String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last! as String
    }
    
}

extension UIView {
    
    static func getUINib() -> UINib {
        return UINib(nibName: getClassName(), bundle: Bundle.main)
    }
    
    static func getInstance<T: UIView>(_ t: T.Type) -> T? {
        return T.getUINib().instantiate(withOwner: nil, options: nil).first as? T
    }
    
    func roundedCorners(_ cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
    
    func border(_ width: CGFloat, color: CGColor) {
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
    
    func registerNib(_ cls: UITableViewCell.Type) {
        register(cls.getUINib(), forCellReuseIdentifier: cls.cellReuseIdentifier)
    }
    
}

extension UIViewController {
    
    static func of<T: UIViewController>(_ cls: T.Type) -> T {
        return UIStoryboard(name: cls.getClassName(), bundle: Bundle.main).instantiateViewController(withIdentifier: cls.getClassName()) as! T
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
    
    static var issueOpenColor: UIColor {
        return UIColor(red: 107/255, green: 204/255, blue: 73/255, alpha: 1)
    }
    
    static var issueClosedColor: UIColor {
        return UIColor(red: 189/255, green: 26/255, blue: 0/255, alpha: 1)
    }
    
}

extension Date {
    
    var formattedString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: Foundation.Date(timeIntervalSince1970: Double(self)))
    }
    
}
