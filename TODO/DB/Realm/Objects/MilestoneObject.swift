import Foundation
import RealmSwift

/// RealmのMilestoneテーブルスキーマを規定するRecordObject
class MilestoneObject: Object {
    
    dynamic var id: String = ""
    dynamic var state: String = ""
    dynamic var desc: String = ""
    dynamic var createdAt: RealmDate = 0
    dynamic var updatedAt: RealmDate = 0
    let dueOn: RealmOptional<RealmDate> = RealmOptional<RealmDate>.init()
    var issues: [IssueObject] {
        return linkingObjects(IssueObject.self, forProperty: "milestone")
    }
    
    var openIssuesCount: Int {
        return issues.filter { $0.state == MilestoneState.Open.rawValue }.count
    }
    
    var closedIssuesCount: Int {
        return issues.filter { $0.state == MilestoneState.Closed.rawValue }.count
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
    
    func open() {
        self.state = MilestoneState.Open.rawValue
        self.updatedAt = Int64(NSDate().timeIntervalSince1970)
    }
    
    func close() {
        self.state = MilestoneState.Closed.rawValue
        self.updatedAt = Int64(NSDate().timeIntervalSince1970)
    }
    
}
