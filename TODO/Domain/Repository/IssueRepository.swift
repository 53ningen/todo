
public protocol IssueRepository {
    
    /// Idを指定してIssueを探す
    func findById(id: Id<Issue>) -> Issue?
    
    /// Issueを全件取得する
    func findAll() -> [Issue]

    /// タイトル、説明文からキーワード検索でIssueを探す
    func findByKeyword(keyword: String) -> [Issue]
    
}
