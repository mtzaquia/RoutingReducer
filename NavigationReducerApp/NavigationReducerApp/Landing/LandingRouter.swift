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
                case .root(let rootAction):
                    switch rootAction {
                        case .pushFirst: return .push(.first(.init()))
                        case .presentModal: return .present(.modalRouter(.init(root: .init())))
                        default: break
                    }

                case .modalRoute(let modalAction):
                    switch modalAction {
                        case .modalRouter(.root(.dismiss)): return .dismiss
                        default: break
                    }

                case .route(_, let routeAction):
                    switch routeAction {
                        case .first(.pushSecond): return .push(.second(.init()))
                        case .first(.popToLanding): return .pop()
                        case .second(.popToFirst): return .pop()
                        case .second(.popToRoot): return .pop(toRoot: true)
                        default: break
                    }

                default: break
            }

            return nil
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
