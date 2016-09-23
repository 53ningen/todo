import RxSwift
import Foundation

final class SelectLabelsViewModel {
    
    private lazy var labelsRepository = AppModules.labelRepository
    
    let labels: Variable<[Label]> = Variable<[Label]>([])
    private let selected: Variable<[Label]>
    
    init(selected: Variable<[Label]> = Variable<[Label]>([])) {
        self.selected = selected
    }
    
    func updateLabels() {
        labels.value = labelsRepository.findAll()
    }
    
    func selectLabel(_ label: Label?) {
        guard let label = label else { return }
        if selected.value.any(label) {
            selected.value = selected.value.filter { $0 != label }
        } else {
            selected.value = selected.value + [label]
        }
    }
    
    func isSelected(_ label: Label) -> Bool {
        return selected.value.any(label)
    }
    
}
