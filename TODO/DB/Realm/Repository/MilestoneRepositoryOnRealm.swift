import RealmSwift

public class MilestoneRepositoryOnRealm: MilestoneRepository {
    
    private let realm: Realm = try! Realm()
    
    public func findById(id: Id<Milestone>) -> Milestone? {
        return realm.objectForPrimaryKey(MilestoneObject.self, key: id.value)?.toMilestone
    }
    
    public func findAll() -> [Milestone] {
        return realm.objects(MilestoneObject).flatMap { $0.toMilestone }
    }
    
}

extension MilestoneObject {
    
    var toMilestone: Milestone? {
        guard let s = MilestoneState.of(state) else { return nil }
        let info = MilestoneInfo(state: s, description: desc, createdAt: createdAt, updatedAt: updatedAt, dueOn: dueOn)
        return Milestone(id: Id<Milestone>(value: id), info: info)
    }
    
}
