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

/// Declares a type that can be used in combination with ``RoutedNavigationStack`` for stateful navigation.
///
/// - Important:
///     - The `State` of this reducer **must** conform to ``RoutingState``.
///     - The `Action` of this reducer **must** conform to ``RoutingAction``.
///     - The `Route` of `State` and `Action` must match.
///
/// Usage:
/// ```
/// struct MyRouter: RoutingReducerProtocol {
///     enum Route: Routing {
///         // all route cases with their states...
///
///         enum Action {
///             // all route cases with their actions...
///         }
///
///         var id: UUID {
///             // a custom logic to identify routes...
///         }
///     }
///
///     struct State: RoutingState {
///         let id = UUID()
///         var navigation: Route.NavigationState = .init()
///         var root: MyRootReducer.State
///     }
///
///     enum Action: RoutingAction {
///         case navigation(Route.NavigationAction)
///         case route(UUID, Route.Action)
///         case modalRoute(Route.Action)
///         case root(MyRootReducer.Action)
///     }
///
///     var rootBody: some RootReducer<Self> {
///         // your root reducer...
///     }
///
///     var routeBody: some RouteReducer<Self> {
///         // your scoped reducers for all possible routes declared in `Route`...
///     }
///
///     func navigation(for action: Action) -> Route.NavigationAction? {
///         // your logic to bridge reducer actions to navigation actions...
///     }
/// }
/// ```
public protocol RoutingReducerProtocol<
    Route,
    RootReducer,
    RouteReducer
>: ReducerProtocol
where State: RoutingState, Action: RoutingAction, State.Route == Route, Action.Route == Route {
    /// The ``Routing`` type this reducer interacts with.
    associatedtype Route: Routing

    /// The `ReducerProtocol` type handling your root view.
    associatedtype RootReducer: ReducerProtocol<State.RootState, Action.RootAction>
    /// The `ReducerProtocol` type handling all the possible routes in this flow.
    associatedtype RouteReducer: ReducerProtocol<Route, Route.Action>

    /// The `ReducerProtocol` to handle your root view.
    @ReducerBuilder<State.RootState, Action.RootAction>
    var rootBody: RootReducer { get }

    /// The `ReducerProtocol` to handle all the possible routes in this flow.
    @ReducerBuilder<Route, Route.Action>
    var routeBody: RouteReducer { get }

    /// This function should return the appropriate navigation action based on the
    /// input action from one of the reducers within the flow.

    /// - Parameter action: The `Action` received by any of the reducers described in the flow.
    /// - Returns: The navigation action that should take place, or `nil` if no navigation should
    /// happen.
    func navigation(for action: Action) -> Route.NavigationAction?
}

public extension RoutingReducerProtocol {
    var body: some ReducerProtocol<State, Action> {
        Router(
            navigation(for:),
            rootReducer: { rootBody },
            routeReducer: { routeBody }
        )
    }
}
