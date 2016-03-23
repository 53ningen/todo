import Foundation
import RealmSwift

class IssueObject: Object {
    
    dynamic var id: String = ""
    dynamic var title: String = ""
    dynamic var state: String = ""
    let labels: List<LabelObject> = List<LabelObject>()
    dynamic var milestone: MilestoneObject? = nil
    dynamic var locked: Bool = false
    dynamic var createdAt: RealmDate = 0
    dynamic var updatedAt: RealmDate = 0
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["id", "title"]
    }

}
