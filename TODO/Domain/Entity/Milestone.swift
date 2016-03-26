/// マイルストンを表す

public final class MilestoneInfo: EntityInfo {
    
    public let state: MilestoneState
    public let description: String
    public let createdAt: Date
    public let updatedAt: Date
    public let dueOn: Date?
    public let openIssuesCount: Int?
    public let closedIssuesCount: Int?

    public init(state: MilestoneState, description: String, createdAt: Date, updatedAt: Date, dueOn: Date?, openIssuesCount: Int? = nil, closedIssuesCount: Int? = nil) {
        self.state = state
        self.description = description
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.dueOn = dueOn
        self.openIssuesCount = openIssuesCount
        self.closedIssuesCount = closedIssuesCount
    }
    
}

extension MilestoneInfo: Equatable {}
public func ==(lhs: MilestoneInfo, rhs: MilestoneInfo) -> Bool {
    return lhs.state == rhs.state
        && lhs.description == rhs.description
        && lhs.createdAt == rhs.createdAt
        && lhs.updatedAt == rhs.updatedAt
        && lhs.dueOn == rhs.dueOn
        && lhs.openIssuesCount == rhs.openIssuesCount
        && lhs.closedIssuesCount == rhs.closedIssuesCount
}

public final class Milestone: Entity, Equatable {
    
    public typealias INFO = MilestoneInfo
    
    public let id: Id<Milestone>
    public let info: MilestoneInfo
    
    public init(id: Id<Milestone>, info: MilestoneInfo) {
        self.id = id
        self.info = info
    }
    
    public var closed: Bool {
        return info.state != .Open
    }
    
    public func isPastDue(now: Date) -> Bool {
        return now > info.dueOn
    }
    
    public var progress: Float {
        guard let openIssuesCount = info.openIssuesCount, closedIssuesCount = info.closedIssuesCount else { return 1 }
        let total = Float(openIssuesCount) + Float(closedIssuesCount)
        return openIssuesCount == 0 ? 1 : Float(openIssuesCount) / total
    }
    
}

public enum MilestoneState: String {
    case Open = "open"
    case Closed = "closed"
    
    public static func of(rawValue: String) -> MilestoneState? {
        switch rawValue {
        case MilestoneState.Open.rawValue: return .Open
        case MilestoneState.Closed.rawValue: return .Closed
        default: return nil
        }
    }
    
}

extension MilestoneState: Equatable {}
public func ==(lhs: MilestoneState, rhs: MilestoneState) -> Bool {
    switch (lhs, rhs) {
    case (.Open, .Open): return true
    case (.Closed, .Closed): return true
    default: return false
    }
}
