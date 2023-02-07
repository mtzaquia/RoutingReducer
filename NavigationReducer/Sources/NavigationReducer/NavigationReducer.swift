//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import protocol SwiftUI.View
import ComposableArchitecture

public struct Router<
    Route: Routing,
    State: RoutingState,
    Action: RoutingAction
>: ReducerProtocol where Route == State.Route, Route == Action.Route {
    public typealias Handler = (Action) -> _RoutingReducer<Route>.Action?
    private let handler: Handler

    public init(_ handler: @escaping Handler) {
        self.handler = handler
    }

    public var body: some ReducerProtocol<State, Action> {
        Reduce { _, action in
            guard let navigationAction = handler(action) else {
                return .none
            }

            return .task { .navigation(navigationAction) }
        }
    }
}

//public struct NavigationReducer<
//    Route: NavigationRoute
//>: ReducerProtocol {
//    public typealias State = NavigationState<Route>
//    public typealias Action = NavigationAction<Route>
//
//    public let rootReducer: Route.RootReducer
//    public let navigationHandler: (Action) -> Route.NavigationAction?
//
//    public init(
//        rootReducer: Route.RootReducer,
//        navigationHandler: @escaping (Action) -> Route.NavigationAction?
//    ) {
//        self.rootReducer = rootReducer
//        self.navigationHandler = navigationHandler
//    }
//
//    public var body: some ReducerProtocol<State, Action> {
//        Reduce { state, action in
//            guard let action = navigationHandler(action) else {
//                return .none
//            }
//
//            return .task { .navigation(action) }
//        }
//        Scope(state: \.navigation, action: /Action.navigation) {
//            _NavigationReducer()
//        }
//        Scope(state: \.root, action: /Action.root) {
//            rootReducer
//        }
//    }
//}
//
//public protocol NavigationReducerProtocol: ReducerProtocol
//where State == NavigationState<Route>,
//      Action == NavigationAction<Route> {
//    associatedtype Route: NavigationRoute
//
////    associatedtype IfLetReducer: ReducerProtocol<Route?, Route.Action>
////    @ReducerBuilder<Route?, Route.Action>
////    func ifCaseLetReducer(_ baseReducer: EmptyReducer<Route?, Route.Action>) -> IfLetReducer
//
//    associatedtype ForEachReducer: ReducerProtocol<Route, Route.Action>
//    @ReducerBuilder<Route, Route.Action>
//    var forEachReducers: ForEachReducer { get }
//
//    func handleNavigation(_ action: NavigationAction<Route>) -> Route.NavigationAction?
//    var rootReducer: Route.RootReducer { get }
//
//    associatedtype RootView: View
//    associatedtype SwitchView: View
//
//    static func rootView(store: StoreOf<Route.RootReducer>) -> RootView
//    static func destinationSwitchStore(
//        store: Store<Route, Route.Action>
//    ) -> SwitchView
//}
//
//public extension NavigationReducerProtocol {
//    @ReducerBuilder<State, Action>
//    var body: some ReducerProtocol<State, Action> {
////        Scope(state: \.navigation.currentModal, action: /Action.destinationModal) { ifCaseLetReducer(EmptyReducer()) }
//        NavigationReducer(rootReducer: rootReducer, navigationHandler: handleNavigation)
//            .forEach(\.navigation.routePath, action: /Action.route) { forEachReducers }
//    }
//}
