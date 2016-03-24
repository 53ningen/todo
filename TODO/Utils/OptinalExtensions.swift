
extension Optional {
    
    func forEach(f: Wrapped -> Void) {
        if let s = self {
            f(s)
        }
    }
    
}
