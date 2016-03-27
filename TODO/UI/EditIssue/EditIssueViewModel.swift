import RxSwift
import Foundation

class EditIssueViewModel {
    
    private lazy var issueRepository: IssueRepository = AppModules.issueRepository
    private lazy var milestoneRepository: MilestoneRepository = AppModules.milestoneRepository
    
    let id: Id<Issue>?
    let title: Variable<String> = Variable<String>("")
    let desc: Variable<String> = Variable<String>("")
    let labels: Variable<[Label]> = Variable<[Label]>([])
    let milestone: Variable<Milestone?> = Variable<Milestone?>(nil)
    let milestones: Variable<[Milestone]> = Variable<[Milestone]>([])
    
    var isNewIssue: Bool {
        return id == nil
    }
    
    init(issue: Issue? = nil) {
        self.id = issue?.id
        if let issue = issue {
            title.value = issue.info.title
            desc.value = issue.info.desc
            labels.value = issue.info.labels
            milestone.value = issue.info.milestone
        }
        milestones.value = milestoneRepository.findAll(.Open)
    }
    
    var submittable: Observable<Bool> {
        return title.asObservable().map { !$0.isEmpty }
    }
    
    func submit() {
        let now: Date = Int64(NSDate().timeIntervalSince1970)
        let info = IssueInfo(title: title.value, desc: desc.value, state: .Open, labels: labels.value, milestone: milestone.value, locked: false, createdAt: now, updatedAt: now)
        if let id = id {
            issueRepository.update(Issue(id: id, info: info))
        } else {
            issueRepository.add(info)
        }
    }
    
}
