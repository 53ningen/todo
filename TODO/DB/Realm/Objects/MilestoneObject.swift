import Foundation
import RealmSwift

class MilestoneObject: Object {
    
    dynamic var id: String = ""
    dynamic var title: String = ""
    dynamic var state: String = ""
    dynamic var desc: String = ""
    dynamic var createdAt: RealmDate = 0
    dynamic var updatedAt: RealmDate = 0
    dynamic var dueOn: RealmDate = 0
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["id"]
    }
    
}
