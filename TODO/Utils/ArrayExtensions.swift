import Foundation

extension Array {
    
    func safeIndex(index: NSIndexPath) -> Element? {
        return safeIndex(index.item)
    }
    
    func safeIndex(index: Int) -> Element? {
        return index < self.count ? self[index] : nil
    }
    
}
