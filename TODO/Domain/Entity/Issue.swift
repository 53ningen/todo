/// Issue を表す

public final class IssueInfo: EntityInfo {

    public let title: String
    public let state: IssueState
    public let labels: [Label]
    public let milestone: Milestone?
    public let locked: Bool
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(title: String, state: IssueState, labels: [Label], milestone: Milestone?, locked: Bool, createdAt: Date, updatedAt: Date) {
        self.title = title
        self.state = state
        self.labels = labels
        self.milestone = milestone
        self.locked = locked
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
}

extension IssueInfo: Equatable {}
public func ==(lhs: IssueInfo, rhs: IssueInfo) -> Bool {
    return lhs.title == rhs.title
        && lhs.state == rhs.state
        && lhs.labels == rhs.labels
        && lhs.milestone == rhs.milestone
        && lhs.locked == rhs.locked
        && lhs.createdAt == rhs.createdAt
        && lhs.updatedAt == rhs.updatedAt
}

public final class Issue: Entity, Equatable {
    
    public typealias INFO = IssueInfo
    
    public let id: Id<Issue>
    public let info: IssueInfo
    
    public init(id: Id<Issue>, info: IssueInfo) {
        self.id = id
        self.info = info
    }
    
    public var closed: Bool {
        return info.state != .Open
    }
    
    public var withNoMilestone: Bool {
        return info.milestone == nil
    }
    
}

extension Issue: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "Issue{id:\(id.value),info:{\(info.debugDescription)}}"
    }
    
}

extension IssueInfo: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "title:\(title),state:\(state.rawValue),labels:\(labels),milestone:\(milestone),locked:\(locked),createdAt:\(createdAt),updatedAt:\(updatedAt)"
    }
    
}

/// Issueの状況
public enum IssueState {
    case Open
    case Closed(closedAt: Date)
    
    public var rawValue: String {
        switch self {
        case .Open: return "open"
        case .Closed(closedAt: _): return "closed"
        }
    }
    
    public var closedAt: Date? {
        switch self {
        case .Open: return nil
        case .Closed(closedAt: let date): return date
        }
    }
    
    public static func of(rawValue: String, closedAt: Date?) -> IssueState? {
        if rawValue == "open" {
            return .Open
        } else if rawValue == "closed" {
            return closedAt.map { .Closed(closedAt: $0) }
        } else {
            return nil
        }
    }
}

extension IssueState: Equatable {}
public func ==(lhs: IssueState, rhs: IssueState) -> Bool {
    switch (lhs, rhs) {
    case (.Open, .Open): return true
    case (.Closed(let l), .Closed(closedAt: let r)): return l == r
    default: return false
    }
}

/// Issueのソート条件
public enum IssueSort {
    case CreatedAtDesc
    case CreatedAtAsc
    case UpdatedAtDesc
    case UpdatedAtAsc
}
