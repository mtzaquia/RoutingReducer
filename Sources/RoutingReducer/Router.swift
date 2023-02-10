//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture

public struct Router<
    Route: Routing,
    State: RoutingState,
    Action: RoutingAction,
    RootReducer: ReducerProtocol<State.RootState, Action.RootAction>,
    RouteReducer: ReducerProtocol<Route, Route.RouteAction>
>: ReducerProtocol where State.Route == Route, Action.Route == Route {
    public typealias Handler = (Action) -> Route.NavigationAction?

    private let handler: Handler
    private let rootReducer: () -> RootReducer
    private let routeReducer: () -> RouteReducer

    public init(
        _ handler: @escaping Handler,
        @ReducerBuilder<State.RootState, Action.RootAction> rootReducer: @escaping () -> RootReducer,
        @ReducerBuilder<Route, Route.RouteAction> routeReducer: @escaping () -> RouteReducer
    ) {
        self.handler = handler
        self.rootReducer = rootReducer
        self.routeReducer = routeReducer
    }

    public var body: some ReducerProtocol<State, Action> {
        Reduce { _, action in
            guard let navigationAction = handler(action) else {
                return .none
            }

            return .task { .navigation(navigationAction) }
        }
        Scope(state: \.navigation, action: /Action.navigation) {
            _RoutingReducer()
        }
        .ifLet(\.navigation.currentModal, action: /Action.modalRoute, then: routeReducer)
        .forEach(\.navigation.routePath, action: /Action.route, routeReducer)
        Scope(state: \.root, action: /Action.root, rootReducer)
    }
}
