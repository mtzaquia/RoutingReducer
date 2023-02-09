//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import NavigationReducer

struct LandingRouter: RoutingReducerProtocol {
    enum Route: Routing {
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

    struct State: RoutingState {
        let id = UUID()
        var navigation: Route.NavigationState = .init()
        var root: Landing.State
    }
    
    enum Action: RoutingAction {
        case navigation(Route.NavigationAction)
        case route(UUID, Route.RouteAction)
        case modalRoute(Route.RouteAction)
        case root(Landing.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Router { action in
            switch action {
                case .root(let rootAction):
                    switch rootAction {
                        case .pushFirst: return .push(.first(.init(isModal: false)))
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
                state: /Route.first,
                action: /Route.RouteAction.first,
                First.init
            )
            Scope(
                state: /Route.second,
                action: /Route.RouteAction.second,
                Second.init
            )
            Scope(
                state: /Route.modalRouter,
                action: /Route.RouteAction.modalRouter,
                ModalRouter.init
            )
        }
    }
}

struct LandingRouterView: View {
    let store: StoreOf<LandingRouter>
    var body: some View {
        NavigationStackWithStore<LandingRouter, _, _>(
            store: store,
            rootView: LandingView.init
        ) { store in
            SwitchStore(store) {
                CaseLet(
                    state: /LandingRouter.Route.first,
                    action: LandingRouter.Route.RouteAction.first,
                    then: FirstView.init
                )
                CaseLet(
                    state: /LandingRouter.Route.second,
                    action: LandingRouter.Route.RouteAction.second,
                    then: SecondView.init
                )
                CaseLet(
                    state: /LandingRouter.Route.modalRouter,
                    action: LandingRouter.Route.RouteAction.modalRouter,
                    then: ModalRouterView.init
                )
            }
        }
    }
}