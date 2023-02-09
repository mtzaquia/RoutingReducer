//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture

/// Describes a state type that belongs to the base of a navigation flow.
///
/// - Important: Conformances to ``RoutingReducerProtocol`` require their `State` to conform to this protocol.
///
/// - Usage:
/// ```
/// struct SomeRouter: RoutingReducerProtocol {
///     enum Route: Routing {
///         // ...
///     }
///
///     struct State: RoutingState {
///         let id = UUID() // `UUID` could be any other `Hashable` type.
///         var navigation: Route.NavigationState = .init()
///         var root: MyRootReducer.State
///     }
///
///     enum Action: RoutingAction {
///         // ...
///     }
///
///     // ...
/// }
/// ```
public protocol RoutingState: Equatable, Hashable, Identifiable {
    /// The ``Routing`` type this action interacts with.
    associatedtype Route: Routing
    /// The type of the state held by any reducer belonging to a ``Routing`` flow.
    associatedtype RootState: RoutedState

    /// The navigation state that holds the current UI representation and path.
    var navigation: Route.NavigationState { get set }
    /// The state belonging to the root reducer of a flow.
    var root: RootState { get set }
}
