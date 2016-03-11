/// TODOリストのアイテムを表す

public final class TodoItemInfo: EntityInfo {

    public let title: String
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(title: String, createdAt: Date, updatedAt: Date) {
        self.title = title
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

}

extension TodoItemInfo: Equatable {}
public func ==(lhs: TodoItemInfo, rhs: TodoItemInfo) -> Bool {
    return lhs.title == rhs.title
        && lhs.createdAt == rhs.createdAt
        && lhs.updatedAt == rhs.updatedAt
}

public final class TodoItem: Entity {
    
    public typealias INFO = TodoItemInfo
    
    public let id: Id<TodoItem>
    public let info: TodoItemInfo
    
    public init(id: Id<TodoItem>, info: TodoItemInfo) {
        self.id = id
        self.info = info
    }

}
