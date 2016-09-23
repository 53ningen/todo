import UIKit

final class MainLabelsViewController: BaseTableViewController {
    
    private let viewModel: MainLabelsViewModel = MainLabelsViewModel()
    
    @IBOutlet weak var createNewButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(LabelCellView.self)
        // tableView上下の余計なスペースを除去するために必要
        tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        if tableView.responds(to: #selector(getter: UITableViewCell.separatorInset)) { tableView.separatorInset = UIEdgeInsets.zero }
        if tableView.responds(to: #selector(getter: UIView.layoutMargins)) { tableView.layoutMargins = UIEdgeInsets.zero }
        navigationItem.title = "Labels"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
        subscribeEvents()
        viewModel.updateLabels()
    }
    
    private func bind() {
        viewModel.labels.asObservable().map { _ in () }.subscribe(onNext: tableView.reloadData).addDisposableTo(disposeBag)
    }
    
    private func subscribeEvents() {
        createNewButton.rx.tap.single()
            .subscribe(onNext: { [weak self] _ in self?.present(UIStoryboard.addLabelViewController, animated: true, completion: nil) })
            .addDisposableTo(disposeBag)
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                if let label = self?.viewModel.labels.value.safeIndex(indexPath.item) {
                    self?.tableView.deselectRow(at: indexPath, animated: true)
                    self?.navigationController?.pushViewController(UIStoryboard.issuesViewController(IssuesQuery.labelQuery(label: label)), animated: true)
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    // DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.labels.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LabelCellView.cellReuseIdentifier, for: indexPath)
        viewModel.labels.value.safeIndex(indexPath.row).forEach {
            (cell as? LabelCellView)?.bind($0)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {}
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .default, title: "delete", handler: { _ in
            let alert = UIAlertController(title: "Delete a label", message: "Once you delete a label, there is no going back. Please be certain.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.viewModel.labels.value.safeIndex(indexPath.item).map { $0.id }.forEach(self.viewModel.remove)
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        })]
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewModel.labels.value.isEmpty ? FooterCellView.noContentView() :FooterCellView.upToDateView()
    }

}
