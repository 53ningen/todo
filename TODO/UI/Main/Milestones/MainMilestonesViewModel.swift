import RxSwift

final class MainMilestonesViewModel {
    
    private let milestoneRepository: MilestoneRepository = AppModules.milestoneRepository
 
    let milestones: Variable<[Milestone]> = Variable<[Milestone]>([])
    let dueOn: Variable<Date?> = Variable<Date?>(nil)
    let segment: Variable<MilestoneState> = Variable<MilestoneState>(MilestoneState.Open)
    
    func updateMilestones() {
        milestones.value = milestoneRepository.findAll(segment.value)
    }
    
    func toggleMilestoneState(_ id: Id<Milestone>) {
        switch segment.value {
        case .Open: milestoneRepository.close(id)
        case .Closed: milestoneRepository.open(id)
        }
        updateMilestones()
    }
    
    func remove(_ id: Id<Milestone>) {
        milestoneRepository.remove(id)
        updateMilestones()
    }
    
}
