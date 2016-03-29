import RealmSwift

/// LabelRepositoryのRealm実装
public class LabelRepositoryOnRealm: LabelRepository {
    
    private let realm: Realm = try! Realm()
    
    public func findById(id: Id<Label>) -> Label? {
        return realm.objectForPrimaryKey(LabelObject.self, key: id.value)?.toLabel
    }
    
    public func findAll() -> [Label] {
        return realm.objects(LabelObject).flatMap { $0.toLabel }
    }
    
    public func add(label: Label) {
        try! realm.write {
            realm.add(LabelObject.of(label.id, info: label.info))
        }
    }
    
    public func remove(id: Id<Label>) {
        try! realm.write {
            realm.objectForPrimaryKey(LabelObject.self, key: id.value).forEach {
                self.realm.delete($0)
            }
        }
    }
    
    internal func deleteAll() {
        try! realm.write {
            realm.delete(realm.objects(LabelObject))
        }
    }
    
}

extension LabelObject {

    var toLabel: Label? {
        return Label(id: Id<Label>(value: id), info: LabelInfo(color: (r: r, g: g, b: b, a: a), openIssuesCount: openIssuesCount, closedIssuesCount: closedIssuesCount))
    }
    
}
