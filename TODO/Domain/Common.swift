// ドメイン層で共有するI/Fを定義する
//  ビルド速度向上のため、ファイル分割せずにI/Fの定義をまとめている

/// Identityを表すインターフェース
public struct Id<T> {
// 型パラメタTはPhantom Type: こうすることにより個別のエンティティに対してId型を定義しなくてすみ、
// かつ、各型のエンティティのIdを型レベルで区別できる
    
    public let value: String
    
}

extension Id: Equatable {}
public func ==<T>(lhs: Id<T>, rhs: Id<T>) -> Bool {
    return lhs.value == rhs.value
}

/// Entityを表すインターフェース
public protocol Entity {
    
    associatedtype INFO = EntityInfo
    
    var id: Id<Self> { get }
    var info: INFO { get }
    func sameIdentityAs(other: Self) -> Bool
    
}

extension Entity {

    public func sameIdentityAs(other: Self) -> Bool {
        return self.id  == other.id
    }

}

// EntityInfoがEquatableなときにEntity同士の比較が可能になる
public func ==<T where T: Entity, T.INFO: Equatable>(lhs: T, rhs: T) -> Bool {
    return lhs.sameIdentityAs(rhs) && lhs.info == rhs.info
}

public protocol EntityInfo {}

/// 値オブジェクトは必ずstructとして実装する
protocol ValueObject: Equatable {}
