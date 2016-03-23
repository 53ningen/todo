
public protocol IssueRepository {
    
    /// Idを指定してIssueを探す
    func findById(id: Id<Issue>) -> Issue?
    
    /// 連番Idのoffsetとlimitを指定してIssueを探す
    func findById(offset: Int, limit: Int, sort: IssueSort) -> [Issue]
    
    /// タイトル、説明文からキーワード検索でIssueを探す
    func findByKeyword(keyword: String) -> [Issue]
    
}
