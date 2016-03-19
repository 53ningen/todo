
final class IssuesViewModel {

    /// 表示しているIssueを格納する
    let issues: [Issue]
    /// Issueをすべて取得しおえてるかどうか
    let isUpToDate: Bool

    init(issues: [Issue], isUpToDate: Bool) {
        self.issues = issues
        self.isUpToDate = isUpToDate
    }
    
    static var getInstance: IssuesViewModel {
        return IssuesViewModel(issues: [], isUpToDate: false)
    }
    
}
