import Foundation

enum MainViewState: UIState {
    case IssuesViewState(issues: [Issue])
    case LabelsViewState
    case MilestonesViewState
}

enum MainViewItem {
    case Issues, Labels, Milestones
    static var items: [MainViewItem] { return [.Issues, .Labels, .Milestones] }
}

enum MainViewAction: UIAction {
    case TabBarActionChangeItem(MainViewItem)
    case TableViewActionTappedCell(NSIndexPath)
    case TableViewActionDeleteCell(NSIndexPath)
}

struct MainViewReducer: UIActionReducer {
    
    typealias ActionType = MainViewAction
    typealias StateType = MainViewState
    
    func handleAction(action: ActionType, state: StateType?) -> StateType {
        switch action {
        case .TabBarActionChangeItem(let item):
            switch item {
            case .Issues: return .IssuesViewState(issues: [])
            case .Labels: return .LabelsViewState
            case .Milestones: return .MilestonesViewState
            }
        case .TableViewActionTappedCell(_):
            return .LabelsViewState
        case .TableViewActionDeleteCell(_):
            return .MilestonesViewState
        }
    }
    
}
