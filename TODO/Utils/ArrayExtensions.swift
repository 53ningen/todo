import Foundation

extension Array {
    
    /// IndexOutOfBoundsErrorを防ぐためのユーティリティメソッド
    func safeIndex(_ index: IndexPath) -> Element? {
        return safeIndex((index as NSIndexPath).item)
    }

    /// IndexOutOfBoundsErrorを防ぐためのユーティリティメソッド
    func safeIndex(_ index: Int) -> Element? {
        return index >= 0 && index < self.count ? self[index] : nil
    }
    
    func any(_ p: (Element) -> Bool) -> Bool {
        return filter(p).count > 0
    }

}

extension Array where Element: Equatable {
    
    func any(_ e: Element) -> Bool {
        return any { e == $0 }
    }
    
}
