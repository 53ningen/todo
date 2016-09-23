import UIKit

final class MainMilestonesViewController: BaseViewController {
    
    private lazy var viewModel: MainMilestonesViewModel = MainMilestonesViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createNewButton: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNib(MilestoneCellView.self)
        // tableView上下の余計なスペースを除去するために必要
        tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        if tableView.respondsToSelector(Selector("separatorInset")) {
            tableView.separatorInset = UIEdgeInsetsZero
        }
        if tableView.respondsToSelector(Selector("layoutMargins")) {
            tableView.layoutMargins = UIEdgeInsetsZero
        }
        navigationItem.title = "Milestones"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        bind()
        subscribeEvents()
        viewModel.updateMilestones()
    }
    
    func bind() {
        /// model ~> view
        viewModel.milestones.asObservable().subscribe(onNext: { [weak self] _ in self?.tableView.reloadData() }).addDisposableTo(disposeBag)
        viewModel.segment.asObservable().map { $0.toSegment }.bindTo(segmentedControl.rx_value).addDisposableTo(disposeBag)
        
        // view ~> model
        segmentedControl.rx_value.map { MilestoneState.of($0) }.bindTo(viewModel.segment).addDisposableTo(disposeBag)
    }
    
    private func subscribeEvents() {
        segmentedControl.rx_value.map { _ in () }.subscribe(onNext: viewModel.updateMilestones).addDisposableTo(disposeBag)
        tableView.rx_itemSelected.single()
            .subscribe(onNext: { [weak self] indexPath in
                if let milestone = self?.viewModel.milestones.value.safeIndex(indexPath.item) {
                    self?.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    self?.navigationController?.pushViewController(UIStoryboard.issuesViewController(IssuesQuery.MilestoneQuery(milestone: milestone)), animated: true)
                }
            })
            .addDisposableTo(disposeBag)
        createNewButton.rx_tap.single()
            .subscribe(onNext: { [weak self] _ in
                self?.presentViewController(UIStoryboard.addMilestoneViewController, animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)
    }
    
}

extension MainMilestonesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.milestones.value.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MilestoneCellView.cellReuseIdentifier, forIndexPath: indexPath)
        if let milestone = viewModel.milestones.value.safeIndex(indexPath.item) {
            (cell as? MilestoneCellView)?.bind(milestone)
        }
        return cell
    }

}

extension MainMilestonesViewController: UITableViewDelegate {
 
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 82
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let closeAction = UITableViewRowAction(style: .Normal, title: viewModel.segment.value == .Open ? "close" : "open", handler: { [weak self] _ in
            if let milestone = self?.viewModel.milestones.value.safeIndex(indexPath.item) {
                self?.viewModel.toggleMilestoneState(milestone.id)
            }}
        )
        let deleteAction = UITableViewRowAction(style: .Default, title: "delete", handler: { [weak self] _ in
            if let milestone = self?.viewModel.milestones.value.safeIndex(indexPath.item) {
                let alert = UIAlertController(title: "Delete a label", message: "Once you delete a milestone, there is no going back. Please be certain.", preferredStyle: .Alert)
                let ok = UIAlertAction(title: "OK", style: .Default, handler: { _ in
                    self?.viewModel.remove(milestone.id)
                })
                let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                alert.addAction(cancel)
                alert.addAction(ok)
                self?.presentViewController(alert, animated: true, completion: nil)
            }}
        )
        return [closeAction, deleteAction]
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewModel.milestones.value.isEmpty ? FooterCellView.noContentView() : FooterCellView.upToDateView()
    }
    
}

extension MilestoneState {
    
    var toSegment: Int {
        switch self {
        case .Open: return 0
        case .Closed: return 1
        }
    }
    
    static func of(segment: Int) -> MilestoneState {
        return segment == 1 ? .Closed : .Open
    }
    
}
