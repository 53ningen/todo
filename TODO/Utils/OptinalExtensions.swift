
extension Optional {
    
    /// if-let構文を完結に実現するためのユーティリティメソッド
    func forEach(_ f: (Wrapped) -> Void) {
        if let s = self {
            f(s)
        }
    }
    
}
