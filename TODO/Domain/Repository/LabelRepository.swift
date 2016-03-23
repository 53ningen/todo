
public protocol LabelRepository {
    
    /// Idを指定してLabelを探す
    func findById(id: Id<Label>) -> Label?
    
}
