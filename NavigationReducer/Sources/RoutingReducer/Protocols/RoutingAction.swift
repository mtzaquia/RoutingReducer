//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture

/// Describes an action type that triggers from the base of a navigation flow.
///
/// - Important: Conformances to ``RoutingReducerProtocol`` require their `Action` to conform to this protocol.
///
/// Usage:
/// ```
/// struct SomeRouter: RoutingReducerProtocol {
///     enum Route: Routing {
///         // ...
///     }
///
///     struct State: RoutingState {
///         // ...
///     }
///
///     enum Action: RoutingAction {
///         case navigation(Route.NavigationAction)
///         case route(UUID, Route.RouteAction) // `UUID` could be any other `Hashable` type.
///         case modalRoute(Route.RouteAction)
///         case root(MyRootReducer.Action)
///     }
///
///     // ...
/// }
/// ```
public protocol RoutingAction {
    /// The ``Routing`` type this action interacts with.
    associatedtype Route: Routing
    /// The type of the action sent from the root reducer of this flow.
    associatedtype RootAction

    /// An action that navigates based on a given command.
    static func navigation(_ action: Route.NavigationAction) -> Self
    /// An action that holds actions beloging to the routes, described in a ``Routing`` type.
    static func route(_ id: Route.ID, _ action: Route.RouteAction) -> Self
    /// An action that holds actions beloging to a modal route, described in a ``Routing`` type.
    static func modalRoute(_ action: Route.RouteAction) -> Self
    /// An action that holds actions belonging to the root reducer of this flow.
    static func root(_ action: RootAction) -> Self
}
