
public protocol LabelRepository {
    
    /// Idを指定してLabelを探す
    func findById(id: Id<Label>) -> Label?
    
    /// Labelの全件取得
    func findAll() -> [Label]
    
    /// Labelの追加
    func add(label: Label)
    
    /// Labelの削除
    func remove(id: Id<Label>)
    
}
