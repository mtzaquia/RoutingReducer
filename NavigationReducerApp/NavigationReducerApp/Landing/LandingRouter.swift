//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import Foundation
import ComposableArchitecture
import NavigationReducer

enum LandingRoute: Routing {
    case first(First.State)
    case second(Second.State)
    case modalRouter(ModalRouter.State)

    enum RouteAction {
        case first(First.Action)
        case second(Second.Action)
        case modalRouter(ModalRouter.Action)
    }

    var id: UUID {
        switch self {
            case .first(let state): return state.id
            case .second(let state): return state.id
            case .modalRouter(let state): return state.id
        }
    }
}

struct LandingRouter: RoutingReducerProtocol {
    struct State: RoutingState {
        let id = UUID()
        var navigation: LandingRoute.NavigationState = .init()
        var root: Landing.State
    }
    enum Action: RoutingAction, BindableAction {
        case navigation(LandingRoute.NavigationAction)
        case route(UUID, LandingRoute.RouteAction)
        case modalRoute(LandingRoute.RouteAction)
        case binding(BindingAction<State>)
        case root(Landing.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Router { action in
            switch action {
                case .root(.pushFirst): return .push(.first(.init()))
                case .root(.presentModal): return .present(.modalRouter(.init(root: .init())))
                case .modalRoute(.modalRouter(.root(.dismiss))): return .dismiss
                case .route(_, .first(.pushSecond)): return .push(.second(.init()))
                case .route(_, .first(.popToLanding)): return .pop()
                case .route(_, .second(.popToFirst)): return .pop()
                case .route(_, .second(.popToRoot)): return .pop(toRoot: true)
                default: return nil
            }
        } rootReducer: {
            Landing()
        } routeReducer: {
            Scope(
                state: /LandingRoute.first,
                action: /LandingRoute.RouteAction.first,
                First.init
            )
            Scope(
                state: /LandingRoute.second,
                action: /LandingRoute.RouteAction.second,
                Second.init
            )
            Scope(
                state: /LandingRoute.modalRouter,
                action: /LandingRoute.RouteAction.modalRouter,
                ModalRouter.init
            )
        }
    }
}
