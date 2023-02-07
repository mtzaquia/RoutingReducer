//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import Foundation
import ComposableArchitecture
import NavigationReducer

struct Landing: ReducerProtocol {
    struct State: RoutingState {
        var navigation: _RoutingReducer<AppRoute>.State
        @BindingState var landingText: String = ""
    }
    enum Action: RoutingAction, BindableAction {
        case navigation(_RoutingReducer<AppRoute>.Action)
        case route(UUID, AppRoute.Action)
        case binding(BindingAction<State>)

        case pushFirst
    }
    var body: some ReducerProtocol<State, Action> {
        Router { action in
            switch action {
                case .pushFirst: return .pop()
                case .route: return .push(.first(.init()))
                default: return nil
            }
        }
        BindingReducer()
        Reduce { state, action in
            print("Landing", action)
            return .none
        }
        .forEach(\.navigation.routePath, action: /Action.route) {
            Scope(
                state: /AppRoute.first,
                action: /AppRoute.Action.first,
                First.init
            )
            Scope(
                state: /AppRoute.second,
                action: /AppRoute.Action.second,
                Second.init
            )
        }
    }
}

//extension ReducerProtocol where State: RoutingState, Action: RoutingAction {
//    @inlinable
//    func routing<Element>(
//        @ReducerBuilder<State.Route, Action.Route> _ element: () -> Element
//    ) -> _ForEachReducer<Self, State.Route.ID, Element> where Element: ReducerProtocol<State, Action> {
//        forEach(\.navigation.routePath, action: /Action.route, element)
//    }
//}

struct First: ReducerProtocol {
    struct State: RoutedState {
        let id = UUID()
        @BindingState var firstText: String = ""
    }
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case pushSecond
        case popToLanding
        case present
        case dismiss
    }
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            print("First", action)
            return .none
        }
    }
}

struct Second: ReducerProtocol {
    struct State: RoutedState {
        let id = UUID()
        @BindingState var secondText: String = ""
    }
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case popToFirst
        case popToRoot
        case dismiss
    }
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            print("Second", action)
            return .none
        }
    }
}
