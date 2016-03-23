import Foundation
import RealmSwift

class LabelObject: Object {
    
    dynamic var id: String = ""
    dynamic var color: Int8 = 0x000000
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["id"]
    }
    
}
