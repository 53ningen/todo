
public protocol IssueRepository {
    
    /// Idを指定してIssueを探す
    func findById(_ id: Id<Issue>) -> Issue?
    
    /// Issueを全件取得する
    func findAll() -> [Issue]
    
    /// Issueの状態を指定して全件取得する
    func findAll(_ state: IssueState) -> [Issue]

    /// タイトル、説明文からキーワード検索でIssueを探す
    func findByKeyword(_ keyword: String) -> [Issue]
    
    /// ラベルに紐付いているIssueを探す
    func findByLabel(_ label: Label, state: IssueState) -> [Issue]
    
    /// マイルストンに紐付いているIssueを探す
    func findByMilestone(_ milestone: Milestone, state: IssueState) -> [Issue]
    
    /// Issueを追加する
    func add(_ info: IssueInfo)
    
    /// Issueを更新する
    func update(_ issue: Issue)
    
    /// Issueを閉じる
    func close(_ id: Id<Issue>)
    
    /// Issueを追加する
    func open(_ id: Id<Issue>)

}
