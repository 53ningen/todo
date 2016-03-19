import UIKit

class FooterCellView: UIView {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    static func upToDateView() -> FooterCellView {
        let view = getInstance(FooterCellView.self)!
        view.label.text = "You are up to date."
        view.activityIndicator.hidden = true
        view.activityIndicator.stopAnimating()
        return view
    }
    
    static func updatingView() -> FooterCellView {
        let view = getInstance(FooterCellView.self)!
        view.label.text = ""
        view.activityIndicator.hidden = false
        view.activityIndicator.startAnimating()
        return view
    }
    
}
