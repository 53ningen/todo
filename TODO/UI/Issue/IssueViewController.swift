
import UIKit

final class IssueViewController: BaseViewController {
    
    private lazy var viewModel: IssueViewModel? = nil
    func setViewModel(viewModel: IssueViewModel) {
        self.viewModel = viewModel
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNib(MilestoneCellView.self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        bind()
        subscribeEvents()
        viewModel?.updateIssue()
    }
    
    private func bind() {
        viewModel?.issue.asObservable().map { _ in () }.subscribeNext(tableView.reloadData).addDisposableTo(disposeBag)
    }
    
    private func subscribeEvents() {
        tableView.rx_itemSelected
            .subscribeNext { [weak self] indexPath in
                self?.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                switch IssueViewSection(rawValue: indexPath.section) {
                case .Some(.Info):
                    self?.viewModel?.issue.value?.info.milestone.forEach {
                        let vc = UIStoryboard.issuesViewController(IssuesQuery.MilestoneQuery(milestone: $0))
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                case .Some(.Labels):
                    self?.viewModel?.issue.value?.info.labels.safeIndex(indexPath.item).forEach {
                        let vc = UIStoryboard.issuesViewController(IssuesQuery.LabelQuery(label: $0))
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                    break
                default:
                    break
                }
            }
            .addDisposableTo(disposeBag)
    }
    
}

extension IssueViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IssueViewSection(rawValue: section)?.numberOfRowsInSection(viewModel) ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return IssueViewSection(rawValue: indexPath.section)?.cellForRow(viewModel, indexPath: indexPath) ?? UITableViewCell()
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
}

extension IssueViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return IssueViewSection(rawValue: section)?.heightForHeaderInSection ?? 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return IssueViewSection(rawValue: section)?.viewForHeader(viewModel)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return IssueViewSection(rawValue: indexPath.section)?.heightForRow ?? 0
    }
    
}

private enum IssueViewSection: Int {
    
    case Info = 0
    case Labels = 1
    
    func numberOfRowsInSection(viewModel: IssueViewModel?) -> Int {
        switch self {
        case .Info: return viewModel?.issue.value?.info.milestone == nil ? 0 : 1
        case .Labels: return viewModel?.issue.value?.info.labels.count ?? 0
        }
    }
    
    var heightForRow: CGFloat {
        switch self {
        case .Info: return 82
        case .Labels: return 75
        }
    }
    
    func cellForRow(viewModel: IssueViewModel?, indexPath: NSIndexPath) -> UITableViewCell? {
        switch self {
        case .Info:
            let cell = UIView.getInstance(MilestoneCellView.self)
            if let milestone = viewModel?.issue.value?.info.milestone {
                cell?.bind(milestone)
            }
            return cell
        case .Labels:
            let cell = UIView.getInstance(LabelCellView.self)
            if let label = viewModel?.issue.value?.info.labels.safeIndex(indexPath.item) {
                cell?.bind(label)
            }
            return cell
        }
    }
    
    func viewForHeader(viewModel: IssueViewModel?) -> UIView? {
        switch self {
        case .Info:
            let cell = UIView.getInstance(IssueInfoCellView.self)
            if let issue = viewModel?.issue.value {
                cell?.bind(issue)
            }
            return cell
        case .Labels:
            let cell = UIView.getInstance(HeaderCellView.self)
            cell?.bind("Labels")
            return cell
        }
    }
    
    var heightForHeaderInSection: CGFloat {
        switch self {
        case .Info: return 198
        case .Labels: return 56
        }
    }
    
}
