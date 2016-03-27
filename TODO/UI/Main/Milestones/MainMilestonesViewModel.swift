import RxSwift

final class MainMilestonesViewModel {
    
    private let milestoneRepository: MilestoneRepository = AppModules.milestoneRepository
 
    let milestones: Variable<[Milestone]> = Variable<[Milestone]>([])
    let dueOn: Variable<Date?> = Variable<Date?>(nil)
    let segment: Variable<MilestoneState> = Variable<MilestoneState>(MilestoneState.Open)
    
    func updateMilestones() {
        milestones.value = milestoneRepository.findAll(segment.value)
    }
    
    func toggleMilestoneState(id: Id<Milestone>) {
        switch segment.value {
        case .Open: milestoneRepository.close(id)
        case .Closed: milestoneRepository.open(id)
        }
        updateMilestones()
    }
    
}
