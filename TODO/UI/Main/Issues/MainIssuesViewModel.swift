import RxSwift

final class MainIssuesViewModel {
    
    private lazy var issueRepository: IssueRepository = AppModules.issueRepository

    let issues: Variable<[Issue]> = Variable<[Issue]>([])
    let segment: Variable<IssueState> = Variable<IssueState>(.open)
    
    func updateIssues() {
        issues.value = issueRepository.findAll(segment.value)
    }
    
    func toggleIssueState(_ id: Id<Issue>) {
        switch segment.value {
        case .open: issueRepository.close(id)
        case .closed(closedAt: _): issueRepository.open(id)
        }
        updateIssues()
    }    
    
}
