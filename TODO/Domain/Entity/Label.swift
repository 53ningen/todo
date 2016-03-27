/// ラベルを表す

public final class LabelInfo: EntityInfo {
    
    public let color: Color
    public let openIssuesCount: Int?
    public let closedIssuesCount: Int?
    
    public init(color: Color, openIssuesCount: Int? = nil, closedIssuesCount: Int? = nil) {
        self.color = color
        self.openIssuesCount = openIssuesCount
        self.closedIssuesCount = closedIssuesCount
    }
    
}

extension LabelInfo: Equatable {}
public func ==(lhs: LabelInfo, rhs: LabelInfo) -> Bool {
    return lhs.color == rhs.color
        && lhs.openIssuesCount == rhs.openIssuesCount
        && lhs.closedIssuesCount == rhs.closedIssuesCount
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
