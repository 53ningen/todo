import Foundation

/// アプリケーションの設定値・環境値を取得するためのインターフェースを集約
public protocol ApplicationSettings {
    
    var bundleVersionString: String { get }
    var bundleShortVersionString: String { get }
    
}

public struct DefaultApplicationSettings: ApplicationSettings {}
extension ApplicationSettings {
    
    public var bundleVersionString: String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as! String
    }
    
    public var bundleShortVersionString: String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
    }
    
}
