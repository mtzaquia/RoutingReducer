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
///         case route(UUID, Route.Action) // `UUID` could be any other `Hashable` type.
///         case modalRoute(Route.Action)
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
    static func route(_ id: Route.ID, _ action: Route.Action) -> Self
    /// An action that holds actions beloging to a modal route, described in a ``Routing`` type.
    static func modalRoute(_ action: Route.Action) -> Self
    /// An action that holds actions belonging to the root reducer of this flow.
    static func root(_ action: RootAction) -> Self
}
