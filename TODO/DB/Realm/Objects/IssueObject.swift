import Foundation
import RealmSwift

/// RealmのIssueテーブルスキーマを規定するRecordObject
class IssueObject: Object {
    
    dynamic var id: String = ""
    dynamic var title: String = ""
    dynamic var desc: String = ""
    dynamic var state: String = ""
    let labels: List<LabelObject> = List<LabelObject>() //=> LabelObject と many-to-many のリレーション
    dynamic var milestone: MilestoneObject? = nil       //=> MilestoneObject と one-to-many のリレーション
    dynamic var locked: Bool = false
    dynamic var createdAt: RealmDate = 0
    dynamic var updatedAt: RealmDate = 0
    let closedAt: RealmOptional<RealmDate> = RealmOptional<RealmDate>.init()
    
    static func of(id: String, info: IssueInfo) -> IssueObject {
        let obj = IssueObject()
        obj.id = id
        obj.title = info.title
        obj.desc = info.desc
        obj.state = info.state.rawValue
        let realm = try! Realm()
        let labelObjs = info.labels.flatMap { realm.objectForPrimaryKey(LabelObject.self, key: $0.id.value) }
        obj.labels.appendContentsOf(labelObjs)
        info.milestone.forEach { obj.milestone = realm.objectForPrimaryKey(MilestoneObject.self, key: $0.id.value) }
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
        self.updatedAt = at
    }
    
    func open() {
        self.state = IssueState.Open.rawValue
        self.closedAt.value = nil
        self.updatedAt = Int64(NSDate().timeIntervalSince1970)
    }
    
    func update(info: IssueInfo) {
        title = info.title
        desc = info.desc
        state = info.state.rawValue
        let realm = try! Realm()
        let labelObjs = info.labels.flatMap { realm.objectForPrimaryKey(LabelObject.self, key: $0.id.value) }
        labels.removeAll()
        labels.appendContentsOf(labelObjs)
        if let milestoneId = info.milestone?.id.value {
            self.milestone = realm.objectForPrimaryKey(MilestoneObject.self, key: milestoneId)
        } else {
           self.milestone = nil
        }
        locked = info.locked
        createdAt = info.createdAt
        updatedAt = info.updatedAt
        closedAt.value = info.state.closedAt
    }

}
