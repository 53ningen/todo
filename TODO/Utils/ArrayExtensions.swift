import Foundation

extension Array {
    
    func safeIndex(index: NSIndexPath) -> Element? {
        return safeIndex(index.item)
    }
    
    func safeIndex(index: Int) -> Element? {
        return index < self.count ? self[index] : nil
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
