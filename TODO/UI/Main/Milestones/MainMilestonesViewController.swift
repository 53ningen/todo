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
        if tableView.respondsToSelector("separatorInset") {
            tableView.separatorInset = UIEdgeInsetsZero
        }
        if tableView.respondsToSelector("layoutMargins") {
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
        viewModel.milestones.asObservable().subscribeNext { [weak self] _ in self?.tableView.reloadData() }.addDisposableTo(disposeBag)
        viewModel.segment.asObservable().map { $0.toSegment }.bindTo(segmentedControl.rx_value).addDisposableTo(disposeBag)
        
        // view ~> model
        segmentedControl.rx_value.map { MilestoneState.of($0) }.bindTo(viewModel.segment).addDisposableTo(disposeBag)
        
    }
    
    private func subscribeEvents() {
        segmentedControl.rx_value.map { _ in () }.subscribeNext(viewModel.updateMilestones).addDisposableTo(disposeBag)
        tableView.rx_itemSelected.single()
            .subscribeNext { [weak self] indexPath in
                let vc = UIViewController.of(IssueViewController.self)
                vc.hidesBottomBarWhenPushed = true
                self?.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            .addDisposableTo(disposeBag)
        createNewButton.rx_tap.single()
            .subscribeNext { [weak self] _ in
                self?.presentViewController(UIViewController.of(AddMilestoneViewController.self), animated: true, completion: nil)
            }
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
