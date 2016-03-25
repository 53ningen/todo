import RxSwift

final class LabelsViewModel {
    
    private lazy var labelRepository: LabelRepository = AppModules.labelRepository
    
    let labels: Variable<[Label]> = Variable<[Label]>([])
    
    func updateLabels() {
        labels.value = labelRepository.findAll()
    }
        
}
