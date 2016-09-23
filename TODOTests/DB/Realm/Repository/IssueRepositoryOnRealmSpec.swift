import Quick
import Nimble
@testable import TODO

class IssueRepositoryOnRealmSpec: QuickSpec {
    
    override func spec() {
        let id1 = Id<Issue>(value: "1")
        let issueInfo = IssueInfo(title: "", desc: "", state: .open, labels: [], milestone: nil, locked: false, createdAt: 0, updatedAt: 0)
        let closedIssueInfo = IssueInfo(title: "", desc: "", state: .closed(closedAt: 0), labels: [], milestone: nil, locked: false, createdAt: 0, updatedAt: 0)
        let repo = IssueRepositoryOnRealm()
        
        beforeEach {
            repo.deleteAll()
        }
        
        describe("IssueRepositoryのRead系が正常に動作する") {
            it("findAll") {
                expect(repo.findAll()).to(equal([]))
                repo.add(issueInfo)
                expect(repo.findAll()).to(equal([Issue(id: id1, info: issueInfo)]))
            }
            it("findById") {
                expect(repo.findById(id1)).to(beNil())
                repo.add(issueInfo)
                expect(repo.findById(id1)).to(equal(Issue(id: Id<Issue>(value: "1"), info: issueInfo)))
            }
            it("findAll(IssueState.Open)") {
                expect(repo.findAll(.open)).to(equal([]))
                repo.add(issueInfo)
                expect(repo.findAll(.open)).to(equal([Issue(id: Id<Issue>(value: "1"), info: issueInfo)]))
            }
            it("findAll(IssueState.Closed)") {
                expect(repo.findAll(.closed(closedAt: 0))).to(equal([]))
                repo.add(closedIssueInfo)
                expect(repo.findAll(.closed(closedAt: 0))).to(equal([Issue(id: Id<Issue>(value: "1"), info: closedIssueInfo)]))
            }
        }
        
        describe("IssueRepositoryのWrite系が正常に動作する") {
            it("open/close") {
                repo.add(issueInfo)
                expect(repo.findAll().safeIndex(0)?.closed).to(beFalse())
                repo.close(id1)
                expect(repo.findAll().safeIndex(0)?.closed).to(beTrue())
                repo.open(id1)
                expect(repo.findAll().safeIndex(0)?.closed).to(beFalse())
            }
        }
        
        afterSuite {
            repo.deleteAll()
        }
    }

}
