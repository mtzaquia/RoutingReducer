//
//  Copyright (c) 2023 @mtzaquia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
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
