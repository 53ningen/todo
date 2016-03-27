import RxSwift

final class IssueViewModel {
    
    private let issueRepository: IssueRepository = AppModules.issueRepository
    
    let id: Id<Issue>
    let issue: Variable<Issue?>
    
    init(id: Id<Issue>) {
        self.id = id
        self.issue = Variable<Issue?>(nil)
    }
    
    func updateIssue() {
        issue.value = issueRepository.findById(id)
    }
    
}
