//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture

/// Declares a type that can be used in combination with ``NavigationStackWithStore`` for stateful navigation.
///
/// - Important:
///     - The `State` of this reducer **must** conform to ``RoutingState``.
///     - The `Action` of this reducer **must** conform to ``RoutingAction``.
///     - The `Route` of `State` and `Action` must match.
public protocol RoutingReducerProtocol<Route>: ReducerProtocol
where State: RoutingState, Action: RoutingAction, State.Route == Route, Action.Route == Route {
    /// The ``Routing`` type this reducer interacts with.
    associatedtype Route: Routing
}
