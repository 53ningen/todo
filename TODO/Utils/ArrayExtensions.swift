import Foundation

extension Array {
    
    /// IndexOutOfBoundsErrorを防ぐためのユーティリティメソッド
    func safeIndex(index: NSIndexPath) -> Element? {
        return safeIndex(index.item)
    }

    /// IndexOutOfBoundsErrorを防ぐためのユーティリティメソッド
    func safeIndex(index: Int) -> Element? {
        return index >= 0 && index < self.count ? self[index] : nil
    }
    
    func any(p: Element -> Bool) -> Bool {
        return filter(p).count > 0
    }

}

extension Array where Element: Equatable {
    
    func any(e: Element) -> Bool {
        return any { e == $0 }
    }
    
}
