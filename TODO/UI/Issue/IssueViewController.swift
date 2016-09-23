
import UIKit

final class IssueViewController: BaseViewController {
    
    fileprivate lazy var viewModel: IssueViewModel? = nil
    func setViewModel(_ viewModel: IssueViewModel) {
        self.viewModel = viewModel
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNib(MilestoneCellView.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
        subscribeEvents()
        viewModel?.updateIssue()
    }
    
    private func bind() {
        viewModel?.issue.asObservable().map { _ in () }.subscribe(onNext: tableView.reloadData).addDisposableTo(disposeBag)
    }
    
    private func subscribeEvents() {
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
                switch IssueViewSection(rawValue: indexPath.section) {
                case .some(.info):
                    self?.viewModel?.issue.value?.info.milestone.forEach {
                        let vc = UIStoryboard.issuesViewController(IssuesQuery.milestoneQuery(milestone: $0))
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                case .some(.labels):
                    self?.viewModel?.issue.value?.info.labels.safeIndex(indexPath.item).forEach {
                        let vc = UIStoryboard.issuesViewController(IssuesQuery.labelQuery(label: $0))
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                    break
                default:
                    break
                }
            })
            .addDisposableTo(disposeBag)
        editButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel?.issue.value.forEach {
                    let vc = UIStoryboard.editIssueViewController()
                    vc.setViewModel(EditIssueViewModel(issue: $0))
                    self?.present(vc, animated: true, completion: nil)
                }
            })
            .addDisposableTo(disposeBag)
    }
    
}

extension IssueViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IssueViewSection(rawValue: section).map {
            switch $0 {
            case .info: return viewModel?.issue.value?.info.milestone == nil ? 0 : 1
            case .labels: return viewModel?.issue.value?.info.labels.count ?? 0
            }
        } ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return IssueViewSection(rawValue: (indexPath as NSIndexPath).section).flatMap {
            switch $0 {
            case .info:
                let cell = UIView.getInstance(MilestoneCellView.self)
                if let milestone = viewModel?.issue.value?.info.milestone {
                    cell?.bind(milestone)
                }
                return cell
            case .labels:
                let cell = UIView.getInstance(LabelCellView.self)
                if let label = viewModel?.issue.value?.info.labels.safeIndex(indexPath.item) {
                    cell?.bind(label)
                }
                return cell
            }
        } ?? UITableViewCell()
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
}

extension IssueViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return IssueViewSection(rawValue: section).map {
            switch $0 {
            case .info: return 210
            case .labels: return 56
            }
            } ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return IssueViewSection(rawValue: section).flatMap { sec in
            switch sec {
            case .info:
                let cell = UIView.getInstance(IssueInfoCellView.self)
                if let issue = self.viewModel?.issue.value {
                    cell?.bind(issue)
                }
                return cell
            case .labels:
                let cell = UIView.getInstance(HeaderCellView.self)
                cell?.bind("Labels")
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return IssueViewSection(rawValue: (indexPath as NSIndexPath).section).map {
            switch $0 {
            case .info: return 82
            case .labels: return 75
            }
        } ?? 0
    }
    
}

fileprivate enum IssueViewSection: Int {
    
    case info = 0
    case labels = 1
    
}
