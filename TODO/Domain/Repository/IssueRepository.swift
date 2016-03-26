
public protocol IssueRepository {
    
    /// Idを指定してIssueを探す
    func findById(id: Id<Issue>) -> Issue?
    
    /// Issueを全件取得する
    func findAll() -> [Issue]
    
    /// Issueの状態を指定して全件取得する
    func findAll(state: IssueState) -> [Issue]

    /// タイトル、説明文からキーワード検索でIssueを探す
    func findByKeyword(keyword: String) -> [Issue]
    
    /// ラベルに紐付いているIssueを探す
    func findByLabel(label: Label, state: IssueState) -> [Issue]
    
    /// マイルストンに紐付いているIssueを探す
    func findByMilestone(milestone: Milestone, state: IssueState) -> [Issue]
    
    /// Issueを追加する
    func add(info: IssueInfo)
    
    /// Issueを閉じる
    func close(id: Id<Issue>)
    
    /// Issueを追加する
    func open(id: Id<Issue>)

}
