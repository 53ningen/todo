import UIKit
import RxSwift
import RxCocoa

final class IssuesViewController: BaseTableViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var createNewButton: UIBarButtonItem!
    
    private let viewModel: IssuesViewModel = IssuesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(IssueCellView.self)
        // tableView上下の余計なスペースを除去するために必要
        tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        if tableView.respondsToSelector("separatorInset") { tableView.separatorInset = UIEdgeInsetsZero }
        if tableView.respondsToSelector("layoutMargins") { tableView.layoutMargins = UIEdgeInsetsZero }
        navigationItem.title = "Issues"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        bind()
        subscribeEvents()
        viewModel.updateIssues()
    }
    
    private func bind() {
        /// model ~> view
        viewModel.issues.asObservable().subscribeNext { [weak self] _ in self?.tableView.reloadData() }.addDisposableTo(disposeBag)
        viewModel.segment.asObservable().map { $0.toSegment }.bindTo(segmentedControl.rx_value).addDisposableTo(disposeBag)

        // view ~> model
        segmentedControl.rx_value.map { IssueState.of($0) }.bindTo(viewModel.segment).addDisposableTo(disposeBag)
    }
    
    private func subscribeEvents() {
        segmentedControl.rx_value.map { _ in () }.subscribeNext(viewModel.updateIssues).addDisposableTo(disposeBag)
        tableView.rx_itemSelected.single()
            .subscribeNext { [weak self] indexPath in
                let vc = UIViewController.of(IssueViewController.self)
                vc.hidesBottomBarWhenPushed = true
                self?.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            .addDisposableTo(disposeBag)
        createNewButton.rx_tap.single()
            .subscribeNext { [weak self] _ in  self?.presentViewController(UIViewController.of(AddIssueViewController.self), animated: true, completion: nil) }
            .addDisposableTo(disposeBag)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.issues.value.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(IssueCellView.cellReuseIdentifier, forIndexPath: indexPath)
        viewModel.issues.value.safeIndex(indexPath.row).forEach {
            (cell as? IssueCellView)?.bind($0)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete: viewModel.issues.value.safeIndex(indexPath.item).map { $0.id }.forEach(viewModel.toggleIssueState)
        default: break
        }
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .Default, title: viewModel.segment.value == .Open ? "close" : "open", handler: { [weak self] _ in
            if let issue = self?.viewModel.issues.value.safeIndex(indexPath.item) {
                self?.viewModel.toggleIssueState(issue.id)
            }
        })]
    }

}

extension IssueState {
    
    var toSegment: Int {
        switch self {
        case .Open: return 0
        case .Closed(closedAt: _): return 1
        }
    }
    
    static func of(segment: Int) -> IssueState {
        return segment == 1 ? .Closed(closedAt: 0) : .Open
    }
    
}
