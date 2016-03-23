import Foundation
import RealmSwift

public class IssueRepositoryOnRealm: IssueRepository {
    
    private let realm: Realm = try! Realm()
    
    public func findById(id: Id<Issue>) -> Issue? {
        return realm.objectForPrimaryKey(IssueObject.self, key: id.value)?.toIssue
    }
    
    public func findAll() -> [Issue] {
        return realm.objects(IssueObject).flatMap { $0.toIssue }
    }
    
    public func findByKeyword(keyword: String) -> [Issue] {
        let pred = NSPredicate(format: "title CONTAINS '%@' OR desc CONTAINS '%@'", keyword, keyword)
        return realm.objects(IssueObject).filter(pred).flatMap { $0.toIssue }
    }
    
}

extension IssueObject {
    
    var toIssue: Issue? {
        guard let state = IssueState.of(state, closedAt: closedAt.value) else { return nil }
        let info = IssueInfo(title: title, state: state, labels: labels.flatMap { $0.toLabel }, milestone: nil, locked: locked, createdAt: createdAt, updatedAt: updatedAt)
        return Issue(id: Id<Issue>(value: id), info: info)
    }
    
}
