import RealmSwift

/// unix time
typealias RealmDate = Int64


/// Realmの初期化などRealm固有の操作を閉じ込めておくI/F
public struct RealmOperator {
    
    public static func deleteAll() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    public static func initialize() {
        Realm.Configuration.defaultConfiguration = config
    }
    
    private static let config = Realm.Configuration(
        // Realm/Objectsを変更したら数字をあげる
        schemaVersion: 1,
        // Migration
        migrationBlock: { _ in
            
        }
    )
    
}
