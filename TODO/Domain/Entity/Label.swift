/// ラベルを表す

public final class LabelInfo: EntityInfo {
    
    public let color: Color
    
    public init(color: Color) {
        self.color = color
    }
    
}

extension LabelInfo: Equatable {}
public func ==(lhs: LabelInfo, rhs: LabelInfo) -> Bool {
    return lhs.color == rhs.color
}

public final class Label: Entity, Equatable {
    
    public typealias INFO = LabelInfo
    
    public let id: Id<Label>
    public let info: LabelInfo
    
    public init(id: Id<Label>, info: LabelInfo) {
        self.id = id
        self.info = info
    }
    
}
