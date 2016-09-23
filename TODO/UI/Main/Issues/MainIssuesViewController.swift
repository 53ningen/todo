import UIKit
import RxSwift
import RxCocoa

final class MainIssuesViewController: BaseViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var createNewButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    private let viewModel: MainIssuesViewModel = MainIssuesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNib(IssueCellView.self)
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
        viewModel.issues.asObservable().subscribe(onNext: { [weak self] _ in self?.tableView.reloadData() }).addDisposableTo(disposeBag)
        viewModel.segment.asObservable().map { $0.toSegment }.bindTo(segmentedControl.rx_value).addDisposableTo(disposeBag)

        // view ~> model
        segmentedControl.rx_value.map { IssueState.of($0) }.bindTo(viewModel.segment).addDisposableTo(disposeBag)
    }

    private func subscribeEvents() {
        segmentedControl.rx_value.map { _ in () }.subscribe(onNext: viewModel.updateIssues).addDisposableTo(disposeBag)
        tableView.rx_itemSelected.single()
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                self?.viewModel.issues.value.safeIndex(indexPath.item).forEach { issue in
                    self?.navigationController?.pushViewController(UIStoryboard.issueViewController(issue.id), animated: true)
                }
            })
            .addDisposableTo(disposeBag)
        createNewButton.rx_tap.single()
            .subscribe(onNext: { [weak self] _ in
                self?.presentViewController(UIStoryboard.editIssueViewController(), animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)
    }

}

extension MainIssuesViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.issues.value.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(IssueCellView.cellReuseIdentifier, forIndexPath: indexPath)
        viewModel.issues.value.safeIndex(indexPath.row).forEach {
            (cell as? IssueCellView)?.bind($0)
        }
        return cell
    }

}

extension MainIssuesViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete: viewModel.issues.value.safeIndex(indexPath.item).map { $0.id }.forEach(viewModel.toggleIssueState)
        default: break
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .Default, title: viewModel.segment.value == .Open ? "close" : "open", handler: { [weak self] _ in
            if let issue = self?.viewModel.issues.value.safeIndex(indexPath.item) {
                self?.viewModel.toggleIssueState(issue.id)
            }
        })]
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewModel.issues.value.isEmpty ? FooterCellView.noContentView() : FooterCellView.upToDateView()
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
