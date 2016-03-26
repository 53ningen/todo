import Foundation
import RealmSwift

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
        let pred = NSPredicate(format: "label == %@ AND state == %@", label.id.value, state.rawValue)
        return realm.objects(IssueObject).filter(pred).flatMap { $0.toIssue }
    }
    
    public func add(info: IssueInfo) {
        try! realm.write {
            realm.add(IssueObject.of(nextId, info: info))
        }
        NSLog("[issue] add \(info.title)")
    }
    
    public func open(id: Id<Issue>) {
        try! realm.write {
            if let obj = realm.objectForPrimaryKey(IssueObject.self, key: id.value) {
                obj.open()
            }
        }
    }
    
    public func close(id: Id<Issue>) {
        try! realm.write {
            if let obj = realm.objectForPrimaryKey(IssueObject.self, key: id.value) {
                obj.close(Int64(NSDate().timeIntervalSince1970))
            }
        }
    }
    
}

extension IssueObject {
    
    var toIssue: Issue? {
        guard let state = IssueState.of(state, closedAt: closedAt.value) else { return nil }
        let info = IssueInfo(title: title, state: state, labels: labels.flatMap { $0.toLabel }, milestone: nil, locked: locked, createdAt: createdAt, updatedAt: updatedAt)
        return Issue(id: Id<Issue>(value: id), info: info)
    }
    
}
