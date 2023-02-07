//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import Foundation
import ComposableArchitecture
import NavigationReducer

struct Landing: RoutingReducerProtocol {
    struct State: RoutingState {
        var navigation: AppRoute.NavigationState = .init()
        @BindingState var landingText: String = ""
    }
    enum Action: RoutingAction, BindableAction {
        case navigation(AppRoute.NavigationAction)
        case route(UUID, AppRoute.RouteAction)
        case binding(BindingAction<State>)

        case pushFirst
    }
    var body: some ReducerProtocol<State, Action> {
        // TODO: Figure out why autocomplete isn't working
        Router { action in
            switch action {
                case .pushFirst: return .push(.first(.init()))
                case .route(_, .first(.popToLanding)): return .pop()
                default: return nil
            }
        } routeReducer: {
            Scope(
                state: /AppRoute.first,
                action: /AppRoute.RouteAction.first,
                First.init
            )
            Scope(
                state: /AppRoute.second,
                action: /AppRoute.RouteAction.second,
                Second.init
            )
        }
        BindingReducer()
        Reduce { state, action in
            return .none
        }
    }
}

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
            return .none
        }
    }
}
