import RxSwift

final class MainLabelsViewModel {
    
    private lazy var labelRepository: LabelRepository = AppModules.labelRepository
    
    let labels: Variable<[Label]> = Variable<[Label]>([])
    
    func updateLabels() {
        labels.value = labelRepository.findAll()
    }
    
    func remove(_ id: Id<Label>) {
        labelRepository.remove(id)
        updateLabels()
    }
    
}
