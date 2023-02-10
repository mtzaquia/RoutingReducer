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

/// Describes a state type that belongs to the base of a navigation flow.
///
/// - Important: Conformances to ``RoutingReducerProtocol`` require their `State` to conform to this protocol.
///
/// Usage:
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
