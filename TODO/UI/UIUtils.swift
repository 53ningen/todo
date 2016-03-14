/// UI層で用いるユーティリティーメソッド

import Foundation

extension NSObject {
    
    func getClassName() -> String {
        return NSStringFromClass(self.dynamicType).componentsSeparatedByString(".").last! as String
    }
    
}
