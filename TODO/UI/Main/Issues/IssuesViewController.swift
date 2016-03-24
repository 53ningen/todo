import UIKit
import RxSwift
import RxCocoa

final class IssuesViewController: BaseTableViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var createNewButton: UIBarButtonItem!
    
    private let viewModel: Variable<IssuesViewModel> = Variable<IssuesViewModel>(IssuesViewModel.getInstance)
    
    private var issues: [Issue] { return viewModel.value.issues }
    private var isUpToDate: Bool { return viewModel.value.isUpToDate }
    
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
    }
    
    private func bind() {
        let observable = viewModel.asObservable().shareReplay(1)
        observable.map { $0.segment.rawValue }.bindTo(segmentedControl.rx_value).addDisposableTo(disposeBag)
    }
    
    private func subscribeEvents() {
        tableView.rx_itemSelected.single()
            .subscribeNext { [weak self] _ in
                let vc = UIViewController.of(IssueViewController.self)
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            .addDisposableTo(disposeBag)
        createNewButton.rx_tap.single()
            .subscribeNext { [weak self] _ in  self?.presentViewController(UIViewController.of(AddIssueViewController.self), animated: true, completion: nil) }
            .addDisposableTo(disposeBag)
        segmentedControl.rx_value
            .subscribeNext { _ in }
            .addDisposableTo(disposeBag)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(IssueCellView.cellReuseIdentifier, forIndexPath: indexPath)
        issues.safeIndex(indexPath.row).forEach {
            (cell as? IssueCellView)?.bind($0)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1 // table上部の余白を消すため
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 35
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return isUpToDate ? FooterCellView.upToDateView() : FooterCellView.updatingView()
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {}
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .Default, title: "close", handler: { _ in })]
    }

}
