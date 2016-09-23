import RealmSwift
import Foundation

/// MilestoneRepositoryのRealm実装
class MilestoneRepositoryOnRealm: MilestoneRepository {
    
    private let realm: Realm = try! Realm()
    
    func findById(_ id: Id<Milestone>) -> Milestone? {
        return realm.object(ofType: MilestoneObject.self, forPrimaryKey: id.value as AnyObject)?.toMilestone
    }
    
    func findAll() -> [Milestone] {
        return realm.objects(MilestoneObject.self).flatMap { $0.toMilestone }
    }
    
    func findAll(_ state: MilestoneState) -> [Milestone] {
        let pred = NSPredicate(format: "state == %@", state.rawValue)
        return realm.objects(MilestoneObject.self).filter(pred).flatMap { $0.toMilestone }
    }
    
    func add(_ milestone: Milestone) {
        try! realm.write {
            realm.add(MilestoneObject.of(milestone.id.value, info: milestone.info))
        }
    }
    
    func remove(_ id: Id<Milestone>) {
        try! realm.write {
            realm.object(ofType: MilestoneObject.self, forPrimaryKey: id.value as AnyObject).forEach {
                self.realm.delete($0)
            }
        }
    }
    
    func open(_ id: Id<Milestone>) {
        try! realm.write {
            if let obj = realm.object(ofType: MilestoneObject.self, forPrimaryKey: id.value as AnyObject) , obj.state == MilestoneState.Closed.rawValue {
                obj.open()
            }
        }
    }
    
    func close(_ id: Id<Milestone>) {
        try! realm.write {
            if let obj = realm.object(ofType: MilestoneObject.self, forPrimaryKey: id.value as AnyObject) , obj.state == MilestoneState.Open.rawValue {
                obj.close()
            }
        }
    }
    
}

extension MilestoneObject {
    
    var toMilestone: Milestone? {
        guard let s = MilestoneState.of(state) else { return nil }
        let info = MilestoneInfo(state: s, description: desc, createdAt: createdAt, updatedAt: updatedAt, dueOn: dueOn.value, openIssuesCount: openIssuesCount, closedIssuesCount: closedIssuesCount)
        return Milestone(id: Id<Milestone>(value: id), info: info)
    }
    
}
