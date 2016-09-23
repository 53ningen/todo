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
    
    static func of(_ id: String, info: IssueInfo) -> IssueObject {
        let obj = IssueObject()
        obj.id = id
        obj.title = info.title
        obj.desc = info.desc
        obj.state = info.state.rawValue
        let realm = try! Realm()
        let labelObjs = info.labels.flatMap { realm.object(ofType: LabelObject.self, forPrimaryKey: $0.id.value as AnyObject) }
        obj.labels.append(objectsIn: labelObjs)
        info.milestone.forEach { obj.milestone = realm.object(ofType: MilestoneObject.self, forPrimaryKey: $0.id.value as AnyObject) }
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
    
    func close(_ at: RealmDate) {
        self.state = IssueState.closed(closedAt: at).rawValue
        self.closedAt.value = at
        self.updatedAt = at
    }
    
    func open() {
        self.state = IssueState.open.rawValue
        self.closedAt.value = nil
        self.updatedAt = Int64(Foundation.Date().timeIntervalSince1970)
    }
    
    func update(_ info: IssueInfo) {
        title = info.title
        desc = info.desc
        state = info.state.rawValue
        let realm = try! Realm()
        let labelObjs = info.labels.flatMap { realm.object(ofType: LabelObject.self, forPrimaryKey: $0.id.value as AnyObject) }
        labels.removeAll()
        labels.append(objectsIn: labelObjs)
        if let milestoneId = info.milestone?.id.value {
            self.milestone = realm.object(ofType: MilestoneObject.self, forPrimaryKey: milestoneId as AnyObject)
        } else {
           self.milestone = nil
        }
        locked = info.locked
        createdAt = info.createdAt
        updatedAt = info.updatedAt
        closedAt.value = info.state.closedAt
    }

}
