import RxSwift
import Foundation

final class IssuesViewModel {
    
    private lazy var issueRepository: IssueRepository = AppModules.issueRepository
    
    let issues: Variable<[Issue]> = Variable<[Issue]>([])
    let segment: Variable<IssueState> = Variable<IssueState>(.Open)
    
    let query: IssuesQuery
    
    init(query: IssuesQuery) {
        self.query = query
    }
    
    func updateIssues() {
        switch query {
        case .LabelQuery(let label): issues.value = issueRepository.findByLabel(label, state: segment.value)
        case .MilestoneQuery(_): issues.value = issueRepository.findAll(segment.value)
        case .KeywordQuery(let keyword): issues.value = issueRepository.findByKeyword(keyword)
        }
    }
    
    func toggleIssueState(id: Id<Issue>) {
        switch segment.value {
        case .Open: issueRepository.close(id)
        case .Closed(closedAt: _): issueRepository.open(id)
        }
        updateIssues()
    }
    
}

enum IssuesQuery {
    case LabelQuery(label: Label)
    case MilestoneQuery(milestone: Milestone)
    case KeywordQuery(keyword: String)
}
