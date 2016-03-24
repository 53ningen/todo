
final class IssuesViewModel {

    /// 表示しているIssueを格納する
    let issues: [Issue]
    /// Issueをすべて取得しおえてるかどうか
    let isUpToDate: Bool
    /// 表示したいIssueの状態
    let segment: Segment
    enum Segment: Int { case Open = 0, Closed = 1 }
    
    init(issues: [Issue], isUpToDate: Bool, segment: Segment) {
        self.issues = issues
        self.isUpToDate = isUpToDate
        self.segment = segment
    }
    
    static var getInstance: IssuesViewModel {
        return IssuesViewModel(issues: [], isUpToDate: false, segment: .Open)
    }
    
}
