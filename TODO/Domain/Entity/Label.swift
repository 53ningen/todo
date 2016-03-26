/// ラベルを表す

public final class LabelInfo: EntityInfo {
    
    public let color: Color
    public let numberOfIssues: Int?
    
    public init(color: Color, numberOfIssues: Int? = nil) {
        self.color = color
        self.numberOfIssues = numberOfIssues
    }
    
}

extension LabelInfo: Equatable {}
public func ==(lhs: LabelInfo, rhs: LabelInfo) -> Bool {
    return lhs.color == rhs.color
        && lhs.numberOfIssues == rhs.numberOfIssues
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

extension Label: CustomDebugStringConvertible {

    public var debugDescription: String {
        return "Label{id:\(id.value),info:{\(info.debugDescription)}}"
    }

}

extension LabelInfo: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "\(color)"
    }
    
}
