import UIKit
import RxSwift

final class SelectLabelsViewController: BaseViewController {
    
    fileprivate lazy var viewModel: SelectLabelsViewModel = SelectLabelsViewModel()
    func setViewModel(_ viewModel: SelectLabelsViewModel) {
        self.viewModel = viewModel
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNib(LabelCellView.self)
        // tableView上下の余計なスペースを除去するために必要
        tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        if tableView.responds(to: #selector(getter: UITableViewCell.separatorInset)) { tableView.separatorInset = UIEdgeInsets.zero }
        if tableView.responds(to: #selector(getter: UIView.layoutMargins)) { tableView.layoutMargins = UIEdgeInsets.zero }
        navigationItem.title = "Select labels"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
        subscribeEvents()
        viewModel.updateLabels()
    }
    
    private func bind() {
        tableView.rx.itemSelected.map { self.viewModel.labels.value.safeIndex($0.item) }.subscribe(onNext: viewModel.selectLabel).addDisposableTo(disposeBag)
        viewModel.labels.asObservable().map { _ in () }.subscribe(onNext: tableView.reloadData).addDisposableTo(disposeBag)
    }
    
    private func subscribeEvents() {
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let accessory = self?.tableView.cellForRow(at: indexPath)?.accessoryType
                self?.tableView.cellForRow(at: indexPath)?.accessoryType =
                    accessory == UITableViewCellAccessoryType.none ? .checkmark : .none
                self?.tableView.cellForRow(at: indexPath)?.isSelected = false
            })
            .addDisposableTo(disposeBag)
        doneButton.rx.tap.single()
            .subscribe(onNext: { self.dismiss(animated: true, completion: nil) })
            .addDisposableTo(disposeBag)
    }
    
}

extension SelectLabelsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.labels.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LabelCellView.cellReuseIdentifier, for: indexPath)
        viewModel.labels.value.safeIndex(indexPath.row).forEach {
            (cell as? LabelCellView)?.bind($0, titleOnly: true)
            cell.accessoryType = self.viewModel.isSelected($0) ? .checkmark : .none
        }
        return cell
    }
    
}

extension SelectLabelsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    @objc(tableView:commitEditingStyle:forRowAtIndexPath:) func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {}
    
}
