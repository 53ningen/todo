import UIKit

final class LabelsViewController: BaseTableViewController {
    
    @IBOutlet weak var createNewButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(LabelCellView.self)
        // tableView上下の余計なスペースを除去するために必要
        tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        if tableView.respondsToSelector("separatorInset") { tableView.separatorInset = UIEdgeInsetsZero }
        if tableView.respondsToSelector("layoutMargins") { tableView.layoutMargins = UIEdgeInsetsZero }
        navigationItem.title = "Labels"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeEvents()
        tableView.reloadData()
    }
    
    private func subscribeEvents() {
        createNewButton.rx_tap.single()
            .subscribeNext { [weak self] _ in  self?.presentViewController(UIViewController.of(AddLabelViewController.self), animated: true, completion: nil) }
            .addDisposableTo(disposeBag)
    }
    
    // DataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(LabelCellView.cellReuseIdentifier, forIndexPath: indexPath)
    }
    
    // Delegate
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1 // table上部の余白を消すため
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {}
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .Default, title: "delete", handler: { _ in })]
    }

}
