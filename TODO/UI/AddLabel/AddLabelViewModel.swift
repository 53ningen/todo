import RxSwift

final class AddLabelViewModel {
    
    let name: Variable<String> = Variable<String>("")
    let color: Variable<Color> = Variable<Color>((127, 127, 127, 1))
    
    convenience init(name: String, color: Color) {
        self.init()
        self.name.value = name
        self.color.value = color
    }
    
    func nextColor(r: Float?, g: Float?, b: Float?) {
        color.value = (r.map { Int($0) } ?? color.value.r, g.map { Int($0) } ?? color.value.g, b.map { Int($0) } ?? color.value.b, 1)
    }
    
    var submittable: Observable<Bool> {
        return name.asObservable().shareReplay(1).map { !$0.isEmpty }
    }
    
    func submit() {
        let info = LabelInfo(color: color.value)
        _ = Label(id: Id<Label>(value: name.value), info: info)
    }
    
}
