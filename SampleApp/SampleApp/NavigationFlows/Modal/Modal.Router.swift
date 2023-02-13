//
//  Copyright (c) 2023 @mtzaquia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import ComposableArchitecture
import SwiftUI
import RoutingReducer

struct ModalRouter: RoutingReducerProtocol {
    enum Route: Routing {
        case first(First.State)

        enum Action {
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
        case route(Route.ID, Route.Action)
        case modalRoute(Route.Action)
        case binding(BindingAction<State>)
        case root(Modal.Action)
    }

    var rootBody: some RootReducer<Self> {
        Modal()
    }

    var routeBody: some RouteReducer<Self> {
        Scope(
            state: /Route.first,
            action: /Route.Action.first,
            First.init
        )
    }

    func navigation(for action: Action) -> Route.NavigationAction? {
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
    }
}

struct ModalRouterView: View {
    let store: StoreOf<ModalRouter>
    var body: some View {
        NavigationStackWithStore(
//        NavigationControllerWithStore(
            store: store,
            rootView: ModalView.init
        ) { store in
            SwitchStore(store) {
                CaseLet(
                    state: /ModalRouter.Route.first,
                    action: ModalRouter.Route.Action.first,
                    then: FirstView.init
                )
            }
        }
    }
}
