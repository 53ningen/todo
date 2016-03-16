/// UI層 で unidirectional data flow を実現するためのベースコンポーネント群

protocol UIState {}
protocol UIAction {}
protocol UIActionReducer {
    
    typealias ActionType: UIAction
    typealias StateType: UIState
    
    func handleAction(action: ActionType, state: StateType?) ->  StateType
    
}
