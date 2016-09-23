import UIKit

final class MainMilestonesViewController: BaseViewController {
    
    fileprivate lazy var viewModel: MainMilestonesViewModel = MainMilestonesViewModel()
    
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
        if tableView.responds(to: #selector(getter: UITableViewCell.separatorInset)) {
            tableView.separatorInset = UIEdgeInsets.zero
        }
        if tableView.responds(to: #selector(getter: UIView.layoutMargins)) {
            tableView.layoutMargins = UIEdgeInsets.zero
        }
        navigationItem.title = "Milestones"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
        subscribeEvents()
        viewModel.updateMilestones()
    }
    
    func bind() {
        /// model ~> view
        viewModel.milestones.asObservable().subscribe(onNext: { [weak self] _ in self?.tableView.reloadData() }).addDisposableTo(disposeBag)
        viewModel.segment.asObservable().map { $0.toSegment }.bindTo(segmentedControl.rx.value).addDisposableTo(disposeBag)
        
        // view ~> model
        segmentedControl.rx.value.map { MilestoneState.of($0) }.bindTo(viewModel.segment).addDisposableTo(disposeBag)
    }
    
    private func subscribeEvents() {
        segmentedControl.rx.value.map { _ in () }.subscribe(onNext: viewModel.updateMilestones).addDisposableTo(disposeBag)
        tableView.rx.itemSelected.single()
            .subscribe(onNext: { [weak self] indexPath in
                if let milestone = self?.viewModel.milestones.value.safeIndex(indexPath.item) {
                    self?.tableView.deselectRow(at: indexPath, animated: true)
                    self?.navigationController?.pushViewController(UIStoryboard.issuesViewController(IssuesQuery.milestoneQuery(milestone: milestone)), animated: true)
                }
            })
            .addDisposableTo(disposeBag)
        createNewButton.rx.tap.single()
            .subscribe(onNext: { [weak self] _ in
                self?.present(UIStoryboard.addMilestoneViewController, animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)
    }
    
}

extension MainMilestonesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.milestones.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MilestoneCellView.cellReuseIdentifier, for: indexPath)
        if let milestone = viewModel.milestones.value.safeIndex(indexPath.item) {
            (cell as? MilestoneCellView)?.bind(milestone)
        }
        return cell
    }

}

extension MainMilestonesViewController: UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let closeAction = UITableViewRowAction(style: .normal, title: viewModel.segment.value == .Open ? "close" : "open", handler: { [weak self] _ in
            if let milestone = self?.viewModel.milestones.value.safeIndex(indexPath.item) {
                self?.viewModel.toggleMilestoneState(milestone.id)
            }}
        )
        let deleteAction = UITableViewRowAction(style: .default, title: "delete", handler: { [weak self] _ in
            if let milestone = self?.viewModel.milestones.value.safeIndex(indexPath.item) {
                let alert = UIAlertController(title: "Delete a label", message: "Once you delete a milestone, there is no going back. Please be certain.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self?.viewModel.remove(milestone.id)
                })
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancel)
                alert.addAction(ok)
                self?.present(alert, animated: true, completion: nil)
            }}
        )
        return [closeAction, deleteAction]
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
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
    
    static func of(_ segment: Int) -> MilestoneState {
        return segment == 1 ? .Closed : .Open
    }
    
}
