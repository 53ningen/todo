import RealmSwift

/// LabelRepositoryのRealm実装
class LabelRepositoryOnRealm: LabelRepository {
    
    private let realm: Realm = try! Realm()
    
    func findById(_ id: Id<Label>) -> Label? {
        return realm.object(ofType: LabelObject.self, forPrimaryKey: id.value as AnyObject)?.toLabel
    }
    
    func findAll() -> [Label] {
        return realm.objects(LabelObject.self).flatMap { $0.toLabel }
    }
    
    func add(_ label: Label) {
        try! realm.write {
            realm.add(LabelObject.of(label.id, info: label.info))
        }
    }
    
    func remove(_ id: Id<Label>) {
        try! realm.write {
            realm.object(ofType: LabelObject.self, forPrimaryKey: id.value as AnyObject).forEach {
                self.realm.delete($0)
            }
        }
    }
    
    internal func deleteAll() {
        try! realm.write {
            realm.delete(realm.objects(LabelObject.self))
        }
    }
    
}

extension LabelObject {

    var toLabel: Label? {
        return Label(id: Id<Label>(value: id), info: LabelInfo(color: (r: r, g: g, b: b, a: a), openIssuesCount: openIssuesCount, closedIssuesCount: closedIssuesCount))
    }
    
}
