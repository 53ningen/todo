import RxSwift
import Foundation

final class AddMilestoneViewModel {
    
    let title: Variable<String> = Variable<String>("")
    let desc: Variable<String> = Variable<String>("")
    let dueOn: Variable<NSDate> = Variable<NSDate>(NSDate())
    
    func submit() {
        let now: Date = Int64(NSDate().timeIntervalSince1970)
        let dueOn: Date = Int64(self.dueOn.value.timeIntervalSince1970)
        _ = MilestoneInfo(title: title.value, state: .Open, description: desc.value, createdAt: now, updatedAt: now, dueOn: dueOn)
    }
    
}
