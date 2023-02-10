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

/// Describes a set of routes supported by a specific flow, their actions and IDs.
///
/// You **can** nest ``Routing`` types for more complex navigation patterns.
///
/// Usage:
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
    /// A convenience alias for ``RoutingReducer<Self>.State``.
    typealias NavigationState = RoutingReducer<Self>.State
    /// A convenience alias for ``RoutingReducer<Self>.Action``.
    typealias NavigationAction = RoutingReducer<Self>.Action

    /// The set of actions for all possible routes described by this type.
    associatedtype RouteAction
}

