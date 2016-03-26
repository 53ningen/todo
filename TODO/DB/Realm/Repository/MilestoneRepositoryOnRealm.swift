import RealmSwift
import Foundation

public class MilestoneRepositoryOnRealm: MilestoneRepository {
    
    private let realm: Realm = try! Realm()
    
    public func findById(id: Id<Milestone>) -> Milestone? {
        return realm.objectForPrimaryKey(MilestoneObject.self, key: id.value)?.toMilestone
    }
    
    public func findAll(state: MilestoneState) -> [Milestone] {
        let pred = NSPredicate(format: "state == %@", state.rawValue)
        return realm.objects(MilestoneObject).filter(pred).flatMap { $0.toMilestone }
    }
    
    public func add(milestone: Milestone) {
        try! realm.write {
            realm.add(MilestoneObject.of(milestone.id.value, info: milestone.info))
        }
    }
    
}

extension MilestoneObject {
    
    var toMilestone: Milestone? {
        guard let s = MilestoneState.of(state) else { return nil }
        let info = MilestoneInfo(state: s, description: desc, createdAt: createdAt, updatedAt: updatedAt, dueOn: dueOn.value)
        return Milestone(id: Id<Milestone>(value: id), info: info)
    }
    
}
