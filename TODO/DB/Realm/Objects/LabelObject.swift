import Foundation
import RealmSwift

class LabelObject: Object {
    
    dynamic var id: String = ""
    dynamic var r: Int = 0
    dynamic var g: Int = 0
    dynamic var b: Int = 0
    dynamic var a: Int = 1
    
    static func of(id: Id<Label>, info: LabelInfo) -> LabelObject {
        let object = LabelObject()
        object.id = id.value
        (object.r, object.g, object.b, object.a) = (info.color.r, info.color.g, info.color.b, info.color.a)
        return object
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["id"]
    }
    
}
