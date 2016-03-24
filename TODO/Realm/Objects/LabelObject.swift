import Foundation
import RealmSwift

class LabelObject: Object {
    
    dynamic var id: String = ""
    dynamic var r: Int = 0
    dynamic var g: Int = 0
    dynamic var b: Int = 0
    dynamic var a: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["id"]
    }
    
}
