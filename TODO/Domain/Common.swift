/// ドメイン層で共有するI/Fを定義する
//  ビルド速度向上のため、ファイル分割せずにI/Fの定義をまとめている

public struct Id<T> {
    
    public let value: String
    
}

extension Id: Equatable {}
public func ==<T>(lhs: Id<T>, rhs: Id<T>) -> Bool {
    
    return lhs.value == rhs.value
    
}

public protocol Entity {
    
    typealias INFO = EntityInfo
    
    var id: Id<Self> { get }
    var info: INFO { get }
    func sameIdentityAs(other: Self) -> Bool
    
}

extension Entity {

    public func sameIdentityAs(other: Self) -> Bool {
        return self.id  == other.id
    }

}

public func ==<T where T: Entity, T.INFO: Equatable>(lhs: T, rhs: T) -> Bool {
    return lhs.sameIdentityAs(rhs) && lhs.info == rhs.info
}

public protocol EntityInfo {}

/// 値オブジェクトは必ずstructとして実装する
protocol ValueObject: Equatable {}
