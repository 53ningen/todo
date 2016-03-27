import UIKit
import RxSwift

final class IssuesViewController: BaseViewController {
    
    private var viewModel: IssuesViewModel?
    func setViewModel(viewModel: IssuesViewModel) {
        self.viewModel = viewModel
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
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
        viewModel?.updateIssues()
    }
    
    private func bind() {
        guard let viewModel = viewModel else { return }
        /// model ~> view
        viewModel.issues.asObservable().subscribeNext { [weak self] _ in self?.tableView.reloadData() }.addDisposableTo(disposeBag)
        viewModel.segment.asObservable().map { $0.toSegment }.bindTo(segmentedControl.rx_value).addDisposableTo(disposeBag)
        
        // view ~> model
        segmentedControl.rx_value.map { IssueState.of($0) }.bindTo(viewModel.segment).addDisposableTo(disposeBag)
    }
    
    private func subscribeEvents() {
        guard let viewModel = viewModel else { return }
        segmentedControl.rx_value.map { _ in () }.subscribeNext(viewModel.updateIssues).addDisposableTo(disposeBag)
        tableView.rx_itemSelected.single()
            .subscribeNext { [weak self] indexPath in
                self?.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                self?.navigationController?.pushViewController(UIStoryboard.issueViewController, animated: true)
            }
            .addDisposableTo(disposeBag)
    }
    
}

extension IssuesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.issues.value.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(IssueCellView.cellReuseIdentifier, forIndexPath: indexPath)
        viewModel?.issues.value.safeIndex(indexPath.row).forEach {
            (cell as? IssueCellView)?.bind($0)
        }
        return cell
    }
    
}
extension IssuesViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete: viewModel?.issues.value.safeIndex(indexPath.item).map { $0.id }.forEach { self.viewModel?.toggleIssueState($0) }
        default: break
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .Default, title: viewModel?.segment.value == .Open ? "close" : "open", handler: { [weak self] _ in
            if let issue = self?.viewModel?.issues.value.safeIndex(indexPath.item) {
                self?.viewModel?.toggleIssueState(issue.id)
            }
        })]
    }
    
}
