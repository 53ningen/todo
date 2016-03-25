import RxSwift
import Foundation

class AddIssueViewModel {
    
    private lazy var issueRepository: IssueRepository = AppModules.issueRepository
    
    let title: Variable<String> = Variable<String>("")
    let desc: Variable<String> = Variable<String>("")
    let labels: Variable<[Label]> = Variable<[Label]>([])
    let milestone: Variable<Milestone?> = Variable<Milestone?>(nil)
    
    var submittable: Observable<Bool> {
        return title.asObservable().map { !$0.isEmpty }
    }
    
    func submit() {
        let now: Date = Int64(NSDate().timeIntervalSince1970)
        let info = IssueInfo(title: title.value, state: .Open, labels: labels.value, milestone: milestone.value, locked: false, createdAt: now, updatedAt: now)
        issueRepository.add(info)
    }
    
}
