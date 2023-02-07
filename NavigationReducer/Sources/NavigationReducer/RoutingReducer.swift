//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import struct SwiftUI.NavigationPath
import ComposableArchitecture

public struct _RoutingReducer<Route: Routing>: ReducerProtocol {
    public struct State: Equatable {
        @BindingState var navigationPath: NavigationPath
        public var routePath: IdentifiedArrayOf<Route>

        public init(
            routePath: IdentifiedArrayOf<Route> = .init()
        ) {
            self.navigationPath = .init(routePath.elements.map(\.id))
            self.routePath = routePath
        }
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case push(Route)
        case pop(toRoot: Bool = false)
    }

    public var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                case .push(let route):
                    state.navigationPath.append(route.id)
                    state.routePath.append(route)
                    return .none
                case .pop(let toRoot):
                    state.navigationPath.removeLast(
                        toRoot ? state.navigationPath.count : min(state.navigationPath.count, 1)
                    )
                    state.routePath.removeLast(
                        toRoot ? state.routePath.count : min(state.routePath.count, 1)
                    )
                    return .none
                case .binding(let action):
                    let difference = state.routePath.count - state.navigationPath.count
                    if action.keyPath == \.$navigationPath, difference > 0 {
                        state.routePath.removeLast(difference)
                    }

                    return .none
            }
        }
    }
}
