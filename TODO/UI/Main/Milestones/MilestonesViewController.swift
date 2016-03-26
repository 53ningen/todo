import UIKit

final class MainMilestonesViewController: BaseTableViewController {
    
    @IBOutlet weak var createNewButton: UIBarButtonItem!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeEvents()
    }
    
    private func subscribeEvents() {
        createNewButton.rx_tap.single()
            .subscribeNext { [weak self] _ in  self?.presentViewController(UIViewController.of(AddMilestoneViewController.self), animated: true, completion: nil) }
            .addDisposableTo(disposeBag)
    }
    
}
