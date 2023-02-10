//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import RoutingReducer

struct ModalRouter: RoutingReducerProtocol {
    enum Route: Routing {
        case first(First.State)

        enum RouteAction {
            case first(First.Action)
        }

        var id: UUID {
            switch self {
                case .first(let state): return state.id
            }
        }
    }

    struct State: RoutingState {
        let id = UUID()
        var navigation: Route.NavigationState = .init()
        var root: Modal.State
    }

    enum Action: RoutingAction, BindableAction {
        case navigation(Route.NavigationAction)
        case route(Route.ID, Route.RouteAction)
        case modalRoute(Route.RouteAction)
        case binding(BindingAction<State>)
        case root(Modal.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Router { action in
            switch action {
                case .root(let rootAction):
                    switch rootAction {
                        case .presentAnother: return .present(.first(.init(isModal: true)))
                        default: break
                    }

                case .modalRoute(let modalAction):
                    switch modalAction {
                        case .first(.dismiss): return .dismiss
                        default: break
                    }
                    
                default: break
            }

            return nil
        } rootReducer: {
            Modal()
        } routeReducer: {
            Scope(
                state: /Route.first,
                action: /Route.RouteAction.first,
                First.init
            )
        }
        BindingReducer()
        Reduce { state, action in
            return .none
        }
    }
}

struct ModalRouterView: View {
    let store: StoreOf<ModalRouter>
    var body: some View {
//        NavigationStackWithStore<ModalRouter, _, _>(
        NavigationControllerWithStore<ModalRouter, _, _>(
            store: store,
            rootView: ModalView.init
        ) { store in
            SwitchStore(store) {
                CaseLet(
                    state: /ModalRouter.Route.first,
                    action: ModalRouter.Route.RouteAction.first,
                    then: FirstView.init
                )
            }
        }
    }
}
