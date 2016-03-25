import RealmSwift

public class LabelRepositoryOnRealm: LabelRepository {
    
    private let realm: Realm = try! Realm()
    
    public func findById(id: Id<Label>) -> Label? {
        return realm.objectForPrimaryKey(LabelObject.self, key: id.value)?.toLabel
    }
    
    public func findAll() -> [Label] {
        return realm.objects(LabelObject).flatMap { $0.toLabel }
    }
    
}

extension LabelObject {

    var toLabel: Label? {
        return Label(id: Id<Label>(value: id), info: LabelInfo(color: (r: r, g: g, b: b, a: a)))
    }
    
}
