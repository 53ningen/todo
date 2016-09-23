import UIKit
import RxSwift
import RxCocoa

final class MainIssuesViewController: BaseViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var createNewButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    fileprivate let viewModel: MainIssuesViewModel = MainIssuesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNib(IssueCellView.self)
        // tableView上下の余計なスペースを除去するために必要
        tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        if tableView.responds(to: #selector(getter: UITableViewCell.separatorInset)) {
            tableView.separatorInset = UIEdgeInsets.zero
        }
        if tableView.responds(to: #selector(getter: UIView.layoutMargins)) {
            tableView.layoutMargins = UIEdgeInsets.zero
        }
        navigationItem.title = "Issues"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
        subscribeEvents()
        viewModel.updateIssues()
    }

    private func bind() {
        /// model ~> view
        viewModel.issues.asObservable().subscribe(onNext: { [weak self] _ in self?.tableView.reloadData() }).addDisposableTo(disposeBag)
        viewModel.segment.asObservable().map { $0.toSegment }.bindTo(segmentedControl.rx.value).addDisposableTo(disposeBag)

        // view ~> model
        segmentedControl.rx.value.map { IssueState.of($0) }.bindTo(viewModel.segment).addDisposableTo(disposeBag)
    }

    private func subscribeEvents() {
        segmentedControl.rx.value.map { _ in () }.subscribe(onNext: viewModel.updateIssues).addDisposableTo(disposeBag)
        tableView.rx.itemSelected.single()
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
                self?.viewModel.issues.value.safeIndex(indexPath.item).forEach { issue in
                    self?.navigationController?.pushViewController(UIStoryboard.issueViewController(issue.id), animated: true)
                }
            })
            .addDisposableTo(disposeBag)
        createNewButton.rx.tap.single()
            .subscribe(onNext: { [weak self] _ in
                self?.present(UIStoryboard.editIssueViewController(), animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)
    }

}

extension MainIssuesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.issues.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IssueCellView.cellReuseIdentifier, for: indexPath)
        viewModel.issues.value.safeIndex(indexPath.row).forEach {
            (cell as? IssueCellView)?.bind($0)
        }
        return cell
    }

}

extension MainIssuesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    @objc(tableView:commitEditingStyle:forRowAtIndexPath:) func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: viewModel.issues.value.safeIndex(indexPath.item).map { $0.id }.forEach(viewModel.toggleIssueState)
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .default, title: viewModel.segment.value == .open ? "close" : "open", handler: { [weak self] _ in
            if let issue = self?.viewModel.issues.value.safeIndex(indexPath.item) {
                self?.viewModel.toggleIssueState(issue.id)
            }
        })]
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewModel.issues.value.isEmpty ? FooterCellView.noContentView() : FooterCellView.upToDateView()
    }

}

extension IssueState {
    
    var toSegment: Int {
        switch self {
        case .open: return 0
        case .closed(closedAt: _): return 1
        }
    }
    
    static func of(_ segment: Int) -> IssueState {
        return segment == 1 ? .closed(closedAt: 0) : .open
    }
    
}
