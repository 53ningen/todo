import RxSwift

final class AddLabelViewModel {
    
    private let labelRepository: LabelRepository = AppModules.labelRepository
    
    let name: Variable<String> = Variable<String>("")
    let color: Variable<Color> = Variable<Color>((127, 127, 127, 1))
    let labels: [Label]
    
    init() {
        self.labels = self.labelRepository.findAll()
    }
    
    convenience init(name: String, color: Color) {
        self.init()
        self.name.value = name
        self.color.value = color
    }
    
    func nextColor(r: Float?, g: Float?, b: Float?) {
        color.value = (r.map { Int($0) } ?? color.value.r, g.map { Int($0) } ?? color.value.g, b.map { Int($0) } ?? color.value.b, 1)
    }
    
    var submittable: Observable<Bool> {
        return name.asObservable().shareReplay(1)
            .map { !$0.isEmpty && !self.labels.map { $0.id.value }.any(self.name.value) }
    }
    
    func submit() {
        let info = LabelInfo(color: color.value)
        let label = Label(id: Id<Label>(value: name.value), info: info)
        labelRepository.add(label)
    }
    
}
