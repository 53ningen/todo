
public protocol MilestoneRepository {
    
    /// Idを指定してMilestoneを探す
    func findById(id: Id<Milestone>) -> Milestone?
    
    /// Milestoneの全件取得
    func findAll(state: MilestoneState) -> [Milestone]
    
    /// Milestoneの追加
    func add(milestone: Milestone)
        
}
