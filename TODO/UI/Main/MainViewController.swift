import UIKit
import RxSwift
import RxCocoa

final class MainViewController: BaseViewController {

    @IBOutlet weak var mainTabBar: UITabBar!
    @IBOutlet weak var issuesItem: UITabBarItem!
    @IBOutlet weak var labelsItem: UITabBarItem!
    @IBOutlet weak var milestonesItem: UITabBarItem!
    @IBOutlet weak var tableView: UITableView!
    
    private let (subject, variable) = (PublishSubject<MainViewAction>(), Variable<MainViewState>(.IssuesViewState(issues: [])))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTabBar.delegate = self
        tableView.registerNib(IssueCellView.self)
        tableView.registerNib(LabelCellView.self)
        tableView.delegate = self
        tableView.dataSource = self
        // tableView上下の余計なスペースを除去するために必要
        tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        if tableView.respondsToSelector("separatorInset") { tableView.separatorInset = UIEdgeInsetsZero }
        if tableView.respondsToSelector("layoutMargins") { tableView.layoutMargins = UIEdgeInsetsZero }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subject.map { [weak self] action in MainViewReducer().handleAction(action, state: self?.variable.value) }
            .doOn(onNext: newState)
            .bindTo(variable)
            .addDisposableTo(disposeBag)
    }
    
    /// アクションを発行する(View -[Action]-> Store <-> Reducer)
    func subscribe() {
        tableView.rx_itemSelected
            .subscribeNext { [weak self] index in
                self?.subject.onNext(MainViewAction.TableViewActionTappedCell(index))
            }
            .addDisposableTo(disposeBag)
        tableView.rx_itemDeleted.subscribeNext { _ in }.addDisposableTo(disposeBag)
    }
    
    /// 状態遷移が発生したらビューに反映する(Store -[State]-> View)
    func newState(state: MainViewState) {
        switch state {
        case .IssuesViewState(_):
            navigationItem.title = "Issues"
        case .LabelsViewState:
            navigationItem.title = "Labels"
        case .MilestonesViewState:
            navigationItem.title = "Milestones"
        }
    }

}

extension MainViewController: UITabBarDelegate {

    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.tag < MainViewItem.items.count {
            subject.onNext(MainViewAction.TabBarActionChangeItem(MainViewItem.items[item.tag]))
        }
    }
    
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1 // table上部の余白を消すため
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {}
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .Default, title: "close", handler: { _ in })]
    }
    
}
extension MainViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(IssueCellView.cellReuseIdentifier, forIndexPath: indexPath)
    }
    
}
