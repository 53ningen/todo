import Foundation
import RealmSwift

/// IssueRepositoryのRealm実装
class IssueRepositoryOnRealm: IssueRepository {
    
    private let realm: Realm = try! Realm()
    
    private var nextId: String {
        if let id = (realm.objects(IssueObject.self).last.flatMap { Int($0.id) }) {
            return String(id + 1)
        } else {
            return "1"
        }
    }
    
    func findById(_ id: Id<Issue>) -> Issue? {
        return realm.object(ofType: IssueObject.self, forPrimaryKey: id.value as AnyObject)?.toIssue
    }
    
    func findAll() -> [Issue] {
        return realm.objects(IssueObject.self).flatMap { $0.toIssue }
    }
    
    func findAll(_ state: IssueState) -> [Issue] {
        let pred = NSPredicate(format: "state == %@", state.rawValue)
        return realm.objects(IssueObject.self).filter(pred).flatMap { $0.toIssue }
    }
    
    func findByKeyword(_ keyword: String) -> [Issue] {
        let pred = NSPredicate(format: "title CONTAINS '%@' OR desc CONTAINS '%@'", keyword, keyword)
        return realm.objects(IssueObject.self).filter(pred).flatMap { $0.toIssue }
    }
    
    func findByLabel(_ label: Label, state: IssueState) -> [Issue] {
        let pred = NSPredicate(format: "id == %@", label.id.value)
        return realm.objects(LabelObject.self)
            .filter(pred)
            .flatMap { $0.issues }
            .flatMap { $0.toIssue }
            .filter {
                switch ($0.info.state, state) {
                case (.open, .open): return true
                case (.closed(_), .closed(_)): return true
                default: return false
                }
            }
    }
    
    func findByMilestone(_ milestone: Milestone, state: IssueState) -> [Issue] {
        let pred = NSPredicate(format: "id == %@", milestone.id.value)
        return realm.objects(MilestoneObject.self)
            .filter(pred)
            .flatMap { $0.issues }
            .flatMap { $0.toIssue }
            .filter {
                switch ($0.info.state, state) {
                case (.open, .open): return true
                case (.closed(_), .closed(_)): return true
                default: return false
                }
        }
    }
    
    func add(_ info: IssueInfo) {
        try! realm.write {
            realm.add(IssueObject.of(nextId, info: info))
        }
    }
    
    func update(_ issue: Issue) {
        try! realm.write {
            if let obj = realm.object(ofType: IssueObject.self, forPrimaryKey: issue.id.value as AnyObject) {
                obj.update(issue.info)
            }
        }
    }
    
    func open(_ id: Id<Issue>) {
        try! realm.write {
            if let obj = realm.object(ofType: IssueObject.self, forPrimaryKey: id.value as AnyObject) , obj.state == IssueState.closed(closedAt: 0).rawValue {
                obj.open()
            }
        }
    }
    
    func close(_ id: Id<Issue>) {
        try! realm.write {
            if let obj = realm.object(ofType: IssueObject.self, forPrimaryKey: id.value as AnyObject) , obj.state == IssueState.open.rawValue {
                obj.close(Int64(NSDate().timeIntervalSince1970))
            }
        }
    }
    
    internal func deleteAll() {
        try! realm.write {
            realm.delete(realm.objects(IssueObject.self))
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
