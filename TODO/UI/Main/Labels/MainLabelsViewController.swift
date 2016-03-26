import UIKit

final class MainLabelsViewController: BaseTableViewController {
    
    private let viewModel: MainLabelsViewModel = MainLabelsViewModel()
    
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
        bind()
        subscribeEvents()
        viewModel.updateLabels()
    }
    
    private func bind() {
        viewModel.labels.asObservable().map { _ in () }.subscribeNext(tableView.reloadData).addDisposableTo(disposeBag)
    }
    
    private func subscribeEvents() {
        createNewButton.rx_tap.single()
            .subscribeNext { [weak self] _ in  self?.presentViewController(UIViewController.of(AddLabelViewController.self), animated: true, completion: nil) }
            .addDisposableTo(disposeBag)
    }
    
    // DataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.labels.value.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(LabelCellView.cellReuseIdentifier, forIndexPath: indexPath)
        viewModel.labels.value.safeIndex(indexPath.row).forEach {
            (cell as? LabelCellView)?.bind($0)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {}
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .Default, title: "delete", handler: { _ in })]
    }

}