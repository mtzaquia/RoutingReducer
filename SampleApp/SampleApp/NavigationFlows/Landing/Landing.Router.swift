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

import SwiftUI
import ComposableArchitecture
import RoutingReducer

struct LandingRouter: RoutingReducerProtocol {
    enum Route: Routing {
        case first(First.State)
        case second(Second.State)
        case modalRouter(ModalRouter.State)

        enum Action {
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
        case route(UUID, Route.Action)
        case modalRoute(Route.Action)
        case root(Landing.Action)
    }

    var rootBody: some RootReducer<Self> {
        Landing()
    }

    var routeBody: some RouteReducer<Self> {
        Scope(
            state: /Route.first,
            action: /Route.Action.first,
            First.init
        )
        Scope(
            state: /Route.second,
            action: /Route.Action.second,
            Second.init
        )
        Scope(
            state: /Route.modalRouter,
            action: /Route.Action.modalRouter,
            ModalRouter.init
        )
    }

    func navigation(for action: Action) -> Route.NavigationAction? {
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
                    case .modalRouter(.root(.replace)): return .present(.first(.init(isModal: true)))
                    case .first(.dismiss): return .dismiss
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
    }
}

struct LandingRouterView: View {
    let store: StoreOf<LandingRouter>
    var body: some View {
        WithRoutingStore(store) { rootStore, navigation, modal in
//            NavigationControllerWithStore(navigation: navigation) {
            NavigationStackWithStore(navigation: navigation) {
                LandingView(store: rootStore)
            }
            .sheet(item: modal.item, content: modal.content)
        } routes: { store in
            SwitchStore(store) {
                CaseLet(
                    state: /LandingRouter.Route.first,
                    action: LandingRouter.Route.Action.first,
                    then: FirstView.init
                )
                CaseLet(
                    state: /LandingRouter.Route.second,
                    action: LandingRouter.Route.Action.second,
                    then: SecondView.init
                )
                CaseLet(
                    state: /LandingRouter.Route.modalRouter,
                    action: LandingRouter.Route.Action.modalRouter,
                    then: ModalRouterView.init
                )
            }
        }
    }
}
