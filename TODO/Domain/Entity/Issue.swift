/// イシューを表すエンティティ
public final class IssueInfo: EntityInfo {

    public let title: String
    public let desc: String
    public let state: IssueState
    public let labels: [Label]
    public let milestone: Milestone?
    public let locked: Bool
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(title: String, desc: String, state: IssueState, labels: [Label], milestone: Milestone?, locked: Bool, createdAt: Date, updatedAt: Date) {
        self.title = title
        self.desc = desc
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
        && lhs.desc == rhs.desc
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
        return info.state != .open
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
        return "title:\(title),desc:\(desc),state:\(state.rawValue),labels:\(labels),milestone:\(milestone.debugDescription),locked:\(locked),createdAt:\(createdAt),updatedAt:\(updatedAt)"
    }
    
}

/// Issueの状況
public enum IssueState {
    case open
    case closed(closedAt: Date)
    
    public var rawValue: String {
        switch self {
        case .open: return "open"
        case .closed(closedAt: _): return "closed"
        }
    }
    
    public var closedAt: Date? {
        switch self {
        case .open: return nil
        case .closed(closedAt: let date): return date
        }
    }
    
    public static func of(_ rawValue: String, closedAt: Date?) -> IssueState? {
        if rawValue == "open" {
            return .open
        } else if rawValue == "closed" {
            return closedAt.map { .closed(closedAt: $0) }
        } else {
            return nil
        }
    }
}

extension IssueState: Equatable {}
public func ==(lhs: IssueState, rhs: IssueState) -> Bool {
    switch (lhs, rhs) {
    case (.open, .open): return true
    case (.closed(let l), .closed(closedAt: let r)): return l == r
    default: return false
    }
}

/// Issueのソート条件
public enum IssueSort {
    case createdAtDesc
    case createdAtAsc
    case updatedAtDesc
    case updatedAtAsc
}
