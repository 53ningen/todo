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
    let closedAt: RealmOptional<RealmDate> = RealmOptional<RealmDate>.init()
    
    static func of(id: String, info: IssueInfo) -> IssueObject {
        let obj = IssueObject()
        obj.id = id
        obj.title = info.title
        obj.state = info.state.rawValue
        obj.labels.appendContentsOf([])
        obj.milestone = nil
        obj.locked = info.locked
        obj.createdAt = info.createdAt
        obj.updatedAt = info.updatedAt
        obj.closedAt.value = info.state.closedAt
        return obj
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["id", "title"]
    }
    
    func close(at: RealmDate) {
        self.state = IssueState.Closed(closedAt: at).rawValue
        self.closedAt.value = at
    }
    
    func open() {
        self.state = IssueState.Open.rawValue
        self.closedAt.value = nil
    }

}