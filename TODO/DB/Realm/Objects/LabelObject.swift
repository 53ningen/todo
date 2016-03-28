import Foundation
import RealmSwift

/// RealmのLabelテーブルスキーマを規定するRecordObject
class LabelObject: Object {
    
    dynamic var id: String = ""
    dynamic var r: Int = 0
    dynamic var g: Int = 0
    dynamic var b: Int = 0
    dynamic var a: Int = 1
    var issues: [IssueObject] {
        return linkingObjects(IssueObject.self, forProperty: "labels")
    }
    
    var openIssuesCount: Int {
        return issues.filter { $0.state == MilestoneState.Open.rawValue }.count
    }
    
    var closedIssuesCount: Int {
        return issues.filter { $0.state == MilestoneState.Closed.rawValue }.count
    }

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
