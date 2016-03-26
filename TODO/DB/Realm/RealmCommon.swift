import RealmSwift

/// unix time
typealias RealmDate = Int64

public struct RealmOperator {
    
    static func deleteAll() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
}
