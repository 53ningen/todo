
extension Optional {
    
    /// if-let構文を完結に実現するためのユーティリティメソッド
    func forEach(f: Wrapped -> Void) {
        if let s = self {
            f(s)
        }
    }
    
}
