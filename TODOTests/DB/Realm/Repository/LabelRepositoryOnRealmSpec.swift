import Quick
import Nimble
@testable import TODO

class LabelRepositoryOnRealmSpec: QuickSpec {
    
    override func spec() {
        let id1 = Id<Label>(value: "1")
        let labelInfo = LabelInfo(color: (0,0,0,0))
        let label = Label(id: id1, info: labelInfo)
        let repo = LabelRepositoryOnRealm()
        
        beforeEach {
            repo.deleteAll()
        }
        
        describe("LabelRepositoryのWrite系が正常に動作する") {
            it("add") {
                expect(repo.findAll()).to(equal([]))
                repo.add(label)
                expect(repo.findAll()).to(equal([label]))
            }
            it("remove") {
                repo.add(label)
                expect(repo.findById(id1)).to(equal(label))
                repo.remove(id1)
                expect(repo.findAll()).to(equal([]))
            }
        }
        describe("LabelRepositoryのRead系が正常に動作する") {
            it("findAll") {
                expect(repo.findAll()).to(equal([]))
                repo.add(label)
                expect(repo.findAll()).to(equal([label]))
            }
            it("findById") {
                expect(repo.findById(id1)).to(beNil())
                repo.add(label)
                expect(repo.findById(id1)).to(equal(label))
            }
        }
    }

}
