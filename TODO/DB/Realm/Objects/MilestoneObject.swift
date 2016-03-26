import Foundation
import RealmSwift

class MilestoneObject: Object {
    
    dynamic var id: String = ""
    dynamic var state: String = ""
    dynamic var desc: String = ""
    dynamic var createdAt: RealmDate = 0
    dynamic var updatedAt: RealmDate = 0
    let dueOn: RealmOptional<RealmDate> = RealmOptional<RealmDate>.init()
    var issues: [IssueObject] {
        return linkingObjects(IssueObject.self, forProperty: "labels")
    }
    
    static func of(id: String, info: MilestoneInfo) -> MilestoneObject {
        let object = MilestoneObject()
        object.id = id
        object.state = info.state.rawValue
        object.desc = info.description
        object.createdAt = info.createdAt
        object.updatedAt = info.updatedAt
        object.dueOn.value = info.dueOn
        return object
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["id"]
    }
    
}
