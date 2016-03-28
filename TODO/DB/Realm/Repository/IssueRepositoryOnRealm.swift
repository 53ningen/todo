import Foundation
import RealmSwift

/// IssueRepositoryのRealm実装
public class IssueRepositoryOnRealm: IssueRepository {
    
    private let realm: Realm = try! Realm()
    
    private var nextId: String {
        if let id = (realm.objects(IssueObject).last.flatMap { Int($0.id) }) {
            return String(id + 1)
        } else {
            return "1"
        }
    }
    
    public func findById(id: Id<Issue>) -> Issue? {
        return realm.objectForPrimaryKey(IssueObject.self, key: id.value)?.toIssue
    }
    
    public func findAll() -> [Issue] {
        return realm.objects(IssueObject).flatMap { $0.toIssue }
    }
    
    public func findAll(state: IssueState) -> [Issue] {
        let pred = NSPredicate(format: "state == %@", state.rawValue)
        return realm.objects(IssueObject).filter(pred).flatMap { $0.toIssue }
    }
    
    public func findByKeyword(keyword: String) -> [Issue] {
        let pred = NSPredicate(format: "title CONTAINS '%@' OR desc CONTAINS '%@'", keyword, keyword)
        return realm.objects(IssueObject).filter(pred).flatMap { $0.toIssue }
    }
    
    public func findByLabel(label: Label, state: IssueState) -> [Issue] {
        let pred = NSPredicate(format: "id == %@", label.id.value)
        return realm.objects(LabelObject)
            .filter(pred)
            .flatMap { $0.issues }
            .flatMap { $0.toIssue }
            .filter {
                switch ($0.info.state, state) {
                case (.Open, .Open): return true
                case (.Closed(_), .Closed(_)): return true
                default: return false
                }
            }
    }
    
    public func findByMilestone(milestone: Milestone, state: IssueState) -> [Issue] {
        let pred = NSPredicate(format: "id == %@", milestone.id.value)
        return realm.objects(MilestoneObject)
            .filter(pred)
            .flatMap { $0.issues }
            .flatMap { $0.toIssue }
            .filter {
                switch ($0.info.state, state) {
                case (.Open, .Open): return true
                case (.Closed(_), .Closed(_)): return true
                default: return false
                }
        }
    }
    
    public func add(info: IssueInfo) {
        try! realm.write {
            realm.add(IssueObject.of(nextId, info: info))
        }
    }
    
    public func update(issue: Issue) {
        try! realm.write {
            if let obj = realm.objectForPrimaryKey(IssueObject.self, key: issue.id.value) {
                obj.update(issue.info)
            }
        }
    }
    
    public func open(id: Id<Issue>) {
        try! realm.write {
            if let obj = realm.objectForPrimaryKey(IssueObject.self, key: id.value) where obj.state == IssueState.Closed(closedAt: 0).rawValue {
                obj.open()
            }
        }
    }
    
    public func close(id: Id<Issue>) {
        try! realm.write {
            if let obj = realm.objectForPrimaryKey(IssueObject.self, key: id.value) where obj.state == IssueState.Open.rawValue {
                obj.close(Int64(NSDate().timeIntervalSince1970))
            }
        }
    }
    
    public func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
}

extension IssueObject {
    
    var toIssue: Issue? {
        guard let state = IssueState.of(state, closedAt: closedAt.value) else { return nil }
        let info = IssueInfo(title: title, desc: desc ,state: state, labels: labels.flatMap { $0.toLabel }, milestone: milestone.flatMap { $0.toMilestone }, locked: locked, createdAt: createdAt, updatedAt: updatedAt)
        return Issue(id: Id<Issue>(value: id), info: info)
    }
    
}
