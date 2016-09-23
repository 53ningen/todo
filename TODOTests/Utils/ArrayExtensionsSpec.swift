import Quick
import Nimble
@testable import TODO

class ArrayExtensionsSpec: QuickSpec {
    
    override func spec() {
        describe("Array#safeIndex(Int)は安全に配列から値を取り出せる") {
            it("インデックス範囲内の値を取得できる") {
                expect([0, 1, 2, 3, 4, 5].safeIndex(0)).to(equal(0))
                expect([0, 1, 2, 3, 4, 5].safeIndex(5)).to(equal(5))
            }
            it("インデックス範囲外を指定するとnilが返る") {
                expect([0, 1, 2, 3, 4, 5].safeIndex(Int.max)).to(beNil())
                expect([0, 1, 2, 3, 4, 5].safeIndex(6)).to(beNil())
                expect([0, 1, 2, 3, 4, 5].safeIndex(-1)).to(beNil())
                expect([0, 1, 2, 3, 4, 5].safeIndex(Int.min)).to(beNil())
            }
        }
        describe("Array#safeIndex(NSIndexPath)は安全に配列から値を取り出せる") {
            it("インデックス範囲内の値を取得できる") {
                expect([0, 1, 2, 3, 4, 5].safeIndex(IndexPath(item: 0, section: 0))).to(equal(0))
                expect([0, 1, 2, 3, 4, 5].safeIndex(IndexPath(item: 5, section: 0))).to(equal(5))
            }
            it("インデックス範囲外を指定するとnilが返る") {
                expect([0, 1, 2, 3, 4, 5].safeIndex(IndexPath(item: Int.max, section: 0))).to(beNil())
                expect([0, 1, 2, 3, 4, 5].safeIndex(IndexPath(item: 6, section: 0))).to(beNil())
                expect([0, 1, 2, 3, 4, 5].safeIndex(IndexPath(item: -1, section: 0))).to(beNil())
                expect([0, 1, 2, 3, 4, 5].safeIndex(IndexPath(item: Int.min, section: 0))).to(beNil())
            }
        }
        describe("Array#any(Element->Bool)") {
            it("true判定ケース") {
                expect([0, 1, 2, 3, 4, 5].any { $0 == 0 }).to(beTrue())
                expect([0, 1, 2, 3, 4, 5].any { $0 == 3 }).to(beTrue())
                expect([0, 1, 2, 3, 4, 5].any { $0 == 5 }).to(beTrue())
            }
            it("false判定ケース") {
                expect([0, 1, 2, 3, 4, 5].any { $0 == -1 }).to(beFalse())
                expect([0, 1, 2, 3, 4, 5].any { $0 == 6 }).to(beFalse())
                expect([].any { $0 == 0 }).to(beFalse())
            }
        }
        describe("Array#any(Element)") {
            it("true判定ケース") {
                expect([0, 1, 2, 3, 4, 5].any(0)).to(beTrue())
                expect([0, 1, 2, 3, 4, 5].any(3)).to(beTrue())
                expect([0, 1, 2, 3, 4, 5].any(5)).to(beTrue())
            }
            it("false判定ケース") {
                expect([0, 1, 2, 3, 4, 5].any(-1)).to(beFalse())
                expect([0, 1, 2, 3, 4, 5].any(6)).to(beFalse())
                expect([].any(0)).to(beFalse())
            }
        }
    }

}
