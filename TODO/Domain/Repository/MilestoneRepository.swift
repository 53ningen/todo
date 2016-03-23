
public protocol MilestoneRepository {
    
    /// Idを指定してMilestoneを探す
    func findById(id: Id<Milestone>) -> Milestone?
    
    /// Idを指定してMilestoneを探す
    func findById(offset: Int, limit: Int) -> Milestone?
    
}
