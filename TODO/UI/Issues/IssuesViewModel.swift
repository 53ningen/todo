import RxSwift
import Foundation

final class IssuesViewModel {
    
    private lazy var issueRepository: IssueRepository = AppModules.issueRepository
    
    let issues: Variable<[Issue]> = Variable<[Issue]>([])
    let segment: Variable<IssueState> = Variable<IssueState>(.open)
    
    let query: IssuesQuery
    
    init(query: IssuesQuery) {
        self.query = query
    }
    
    func updateIssues() {
        switch query {
        case .labelQuery(let label): issues.value = issueRepository.findByLabel(label, state: segment.value)
        case .milestoneQuery(let milestone): issues.value = issueRepository.findByMilestone(milestone, state: segment.value)
        case .keywordQuery(let keyword): issues.value = issueRepository.findByKeyword(keyword)
        }
    }
    
    func toggleIssueState(_ id: Id<Issue>) {
        switch segment.value {
        case .open: issueRepository.close(id)
        case .closed(closedAt: _): issueRepository.open(id)
        }
        updateIssues()
    }
    
}

enum IssuesQuery {
    case labelQuery(label: Label)
    case milestoneQuery(milestone: Milestone)
    case keywordQuery(keyword: String)
}
