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
        case modalRoute(AppRoute.RouteAction)
        case binding(BindingAction<State>)

        case pushFirst
        case presentFirst
    }
    var body: some ReducerProtocol<State, Action> {
        Router { action in
            switch action {
                // TODO: Figure out why autocomplete isn't working
                case .pushFirst: return .push(.first(.init()))
                case .presentFirst: return .present(.first(.init()))
                case .modalRoute(.first(.dismiss)): return .dismiss
                case .route(_, .first(.pushSecond)): return .push(.second(.init()))
                case .route(_, .first(.popToLanding)): return .pop()
                case .route(_, .second(.popToFirst)): return .pop()
                case .route(_, .second(.popToRoot)): return .pop(toRoot: true)
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
