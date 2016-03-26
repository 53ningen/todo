import UIKit
import RxSwift

final class SelectLabelsViewController: BaseViewController {
    
    private lazy var viewModel: SelectLabelsViewModel = SelectLabelsViewModel()
    func setViewModel(viewModel: SelectLabelsViewModel) {
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
        if tableView.respondsToSelector("separatorInset") { tableView.separatorInset = UIEdgeInsetsZero }
        if tableView.respondsToSelector("layoutMargins") { tableView.layoutMargins = UIEdgeInsetsZero }
        navigationItem.title = "Select labels"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        bind()
        subscribeEvents()
        viewModel.updateLabels()
    }
    
    private func bind() {
        tableView.rx_itemSelected.map { self.viewModel.labels.value.safeIndex($0.item) }.subscribeNext(viewModel.selectLabel).addDisposableTo(disposeBag)
        viewModel.labels.asObservable().map { _ in () }.subscribeNext(tableView.reloadData).addDisposableTo(disposeBag)
    }
    
    private func subscribeEvents() {
        tableView.rx_itemSelected
            .subscribeNext { [weak self] indexPath in
                let accessory = self?.tableView.cellForRowAtIndexPath(indexPath)?.accessoryType
                self?.tableView.cellForRowAtIndexPath(indexPath)?.accessoryType =
                    accessory == UITableViewCellAccessoryType.None ? .Checkmark : .None
                self?.tableView.cellForRowAtIndexPath(indexPath)?.selected = false
            }
            .addDisposableTo(disposeBag)
        doneButton.rx_tap.single()
            .subscribeNext { self.dismissViewControllerAnimated(true, completion: nil) }
            .addDisposableTo(disposeBag)
    }
    
}

extension SelectLabelsViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.labels.value.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(LabelCellView.cellReuseIdentifier, forIndexPath: indexPath)
        viewModel.labels.value.safeIndex(indexPath.row).forEach {
            (cell as? LabelCellView)?.bind($0, titleOnly: true)
            cell.accessoryType = self.viewModel.isSelected($0) ? .Checkmark : .None
        }
        return cell
    }
    
}

extension SelectLabelsViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {}
    
}
