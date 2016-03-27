import RxSwift
import Foundation

final class AddMilestoneViewModel {
    
    private let milestoneRepository: MilestoneRepository = AppModules.milestoneRepository
    
    let title: Variable<String> = Variable<String>("")
    let desc: Variable<String> = Variable<String>("")
    let dueOn: Variable<NSDate?> = Variable<NSDate?>(nil)
    let milestones: [Milestone]
    
    init() {
        self.milestones = milestoneRepository.findAll()
    }
    
    var submittable: Observable<Bool> {
        return title.asObservable().shareReplay(1)
            .map { !$0.isEmpty && !self.milestones.map { $0.id.value }.any(self.title.value) }
    }
    
    func submit() {
        let now: Date = Int64(NSDate().timeIntervalSince1970)
        let dueOn: Date? = (self.dueOn.value?.timeIntervalSince1970).map { Int64($0) }
        let info = MilestoneInfo(state: .Open, description: desc.value, createdAt: now, updatedAt: now, dueOn: dueOn)
        let milestone = Milestone(id: Id<Milestone>(value: title.value), info: info)
        milestoneRepository.add(milestone)
    }
    
}
