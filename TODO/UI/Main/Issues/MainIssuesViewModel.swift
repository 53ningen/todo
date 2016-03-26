import RxSwift

final class MainIssuesViewModel {
    
    private lazy var issueRepository: IssueRepository = AppModules.issueRepository

    let issues: Variable<[Issue]> = Variable<[Issue]>([])
    let segment: Variable<IssueState> = Variable<IssueState>(.Open)
    
    func updateIssues() {
        issues.value = issueRepository.findAll(segment.value)
    }
    
    func toggleIssueState(id: Id<Issue>) {
        switch segment.value {
        case .Open: issueRepository.close(id)
        case .Closed(closedAt: _): issueRepository.open(id)
        }
        updateIssues()
    }    
    
}
