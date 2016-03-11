/// ドメイン層で共有するI/Fを定義する
//  ビルド速度向上のため、ファイル分割せずにI/Fの定義をまとめている

import Foundation

public struct Id<T> {
    
    public let value: String
    
}

extension Id: Equatable {}
public func ==<T>(lhs: Id<T>, rhs: Id<T>) -> Bool {
    
    return lhs.value == rhs.value
    
}

public protocol Entity {
    
    var id: Id<Self> { get }
    func sameIdentityAs(other: Self) -> Bool
    
}

extension Entity {

    public func sameIdentityAs(other: Self) -> Bool {
        return self.id  == other.id
    }

}

/// 値オブジェクトは必ずstructとして実装する
protocol ValueObject: Equatable {}
