
public protocol MilestoneRepository {
    
    /// Idを指定してMilestoneを探す
    func findById(_ id: Id<Milestone>) -> Milestone?
    
    /// Milestoneの全件取得
    func findAll() -> [Milestone]
    
    /// Milestoneの状態を指定して取得
    func findAll(_ state: MilestoneState) -> [Milestone]
    
    /// Milestoneの追加
    func add(_ milestone: Milestone)
    
    /// Milestoneの削除
    func remove(_ id: Id<Milestone>)
    
    /// Milestoneのclose
    func close(_ id: Id<Milestone>)
    
    /// Milestoneのopen
    func open(_ id: Id<Milestone>)
        
}
