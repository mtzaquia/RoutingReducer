//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import struct SwiftUI.NavigationPath
import ComposableArchitecture

public enum RoutingReducer<Route: Routing> {
    /// A built-in routing reducer state, usually held by your ``RoutingState``.
    public struct State: Equatable, Hashable {
        @BindingState var routePath: IdentifiedArrayOf<Route>
        var currentModal: Route?

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
//                    if #available(iOS 16, *) {
//                        state.navigationPath.append(route.id)
//                    }

                    state.routePath.append(route)

                    return .none
                case .pop(let toRoot):
//                    if #available(iOS 16, *) {
//                        state.navigationPath.removeLast(
//                            toRoot ? state.navigationPath.count : min(state.navigationPath.count, 1)
//                        )
//                    }

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

//                    if #available(iOS 16, *) {
//                        guard let navigationPath = navigationPath as? NavigationPath else {
//                            return .none
//                        }
//
//
//                    }
//
                    return .none
                case .binding: //(let action):
//                    if #available(iOS 16, *) {
//                        let difference = state.routePath.count - state.navigationPath.count
//                        if action.keyPath == \.$navigationPath, difference > 0 {
//                            state.routePath.removeLast(difference)
//                        }
//                    }

                    return .none
            }
        }
    }
}
