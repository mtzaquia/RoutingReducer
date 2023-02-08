//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture
import NavigationReducer
import SwiftUI

enum ModalRoute: Routing {
//    case first(First.State)

    enum RouteAction {
//        case first(First.Action)
    }

    var id: UUID {
        UUID(uuidString: "modal")!
//        switch self {
//            case .first(let state): return state.id
//        }
    }
}

struct ModalRouter: RoutingReducerProtocol {
    struct State: RoutingState {
        let id = UUID()
        var navigation: ModalRoute.NavigationState = .init()
        var root: Modal.State
    }

    enum Action: RoutingAction, BindableAction {
        case navigation(ModalRoute.NavigationAction)
        case route(ModalRoute.ID, ModalRoute.RouteAction)
        case modalRoute(ModalRoute.RouteAction)
        case binding(BindingAction<State>)
        case root(Modal.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Router { action in
            switch action {
//                case .root(.dismiss): return .dismiss
//                case .presentOtherModal: return .present(.first(.init()))
//                case .modalRoute(.first(.dismiss)): return .dismiss
                default: break
            }

            return nil
        } rootReducer: {
            Modal()
        } routeReducer: {
//            Scope(
//                state: /ModalRoute.first,
//                action: /ModalRoute.RouteAction.first,
//                First.init
//            )
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
        NavigationStackWithStore<ModalRouter, _, _>(
            store: store,
            rootView: ModalView.init
        ) { store in
//            SwitchStore(store) {
//                CaseLet(
//                    state: /ModalRoute.first,
//                    action: ModalRoute.RouteAction.first,
//                    then: FirstView.init
//                )
//            }
            EmptyView()
        }
    }
}
