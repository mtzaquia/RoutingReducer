//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture

/// Describes a set of routes supported by a specific flow, their actions and IDs.
///
/// You **can** nest ``Routing`` types for more complex navigation patterns.
///
/// - Usage:
/// ```
/// struct SomeRouter: RoutingReducerProtocol {
///     enum Route: Routing {
///         case first(First.State)
///         // nesting another ``RoutingReducerProtocol`` is possible.
///         case modalRouter(ModalRouter.State)
///
///         enum RouteAction {
///             case first(First.Action)
///             // nesting another ``RoutingReducerProtocol`` is possible.
///             case modalRouter(ModalRouter.Action)
///         }
///
///         // Using state IDs rather than an ID based on ``self`` allows for the
///         // same screen to be routed to more than once with different state.
///         var id: UUID {
///             switch self {
///                 case .first(let state): return state.id
///                 case .modalRouter(let state): return state.id
///             }
///         }
///     }
///
///     struct State: RoutingState {
///         // ...
///     }
///
///     enum Action: RoutingAction {
///         // ...
///     }
///
///     // ...
/// }
/// ```
public protocol Routing: Equatable, Hashable, Identifiable {
    /// An alias to the built-in routing reducer state, usually held by your ``RoutingState``.
    typealias NavigationState = _RoutingReducer<Self>.State
    /// An alias to the built-in routing reducer action, usually a parameter to the `navigation` case
    /// in your ``RoutingAction``.
    typealias NavigationAction = _RoutingReducer<Self>.Action

    /// The set of actions for all possible routes described by this type.
    associatedtype RouteAction
}

