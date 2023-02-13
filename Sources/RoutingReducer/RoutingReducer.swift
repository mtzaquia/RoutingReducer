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

import struct SwiftUI.NavigationPath
import ComposableArchitecture

public enum RoutingReducer<Route: Routing> {
    /// A built-in routing reducer state, usually held by your ``RoutingState``.
    public struct State: Equatable, Hashable {
        @BindingState var routePath: IdentifiedArrayOf<Route>
        @BindingState var currentModal: Route?

        /// Creates a new ``RoutingReducer.State`` for a specific navigation state.
        ///
        /// - Parameters:
        ///   - routePath: The current path of pushed routes, or empty for being at the root.
        ///   - currentModal: The current modal being presented on this navigation flow.
        public init(
            routePath: IdentifiedArrayOf<Route> = .init(),
            currentModal: Route? = nil
        ) {
            self.routePath = routePath
            self.currentModal = currentModal
        }
    }

    /// A built-in routing reducer action, usually held by your ``RoutingState``.
    public enum Action: BindableAction {
        /// For internal use only. **Do not** call this action directly.
        case _updateNavigationPath(Any)
        /// For internal use only. **Do not** call this action directly.
        case binding(BindingAction<State>)

        /// Pushes a new route onto the stack.
        /// - Parameter route: The ``Route`` to be pushed.
        case push(Route)
        /// Pops a single route from the stack, or goes to root.
        /// - Parameter toRoot: A flag indicating if all routes
        /// should be popped. Defaults to `false`.
        case pop(toRoot: Bool = false)
        /// Presents a route modally.
        /// - Parameter route: The ``Route`` to be modally presented.
        case present(Route)
        /// Dismisses the currently, modally presented route. Does nothing if no modal
        /// is currently presented.
        case dismiss
    }
}

struct _RoutingReducer<Route: Routing>: ReducerProtocol {
    typealias State = RoutingReducer<Route>.State
    typealias Action = RoutingReducer<Route>.Action

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                case .present(let route):
                    state.currentModal = route
                    return .none
                case .dismiss:
                    state.currentModal = nil
                    return .none
                case .push(let route):
                    state.routePath.append(route)
                    return .none
                case .pop(let toRoot):
                    state.routePath.removeLast(
                        toRoot ? state.routePath.count : min(state.routePath.count, 1)
                    )

                    return .none
                case ._updateNavigationPath(let navigationPath):
                    guard #available(iOS 16, *),
                          let navigationPath = navigationPath as? NavigationPath
                    else {
                        return .none
                    }

                    let difference = state.routePath.count - navigationPath.count
                    if difference > 0 {
                        state.routePath.removeLast(difference)
                    }

                    return .none
                case .binding:
                    return .none
            }
        }
    }
}
