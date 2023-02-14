//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public final class Navigation<State: RoutingState, Action: RoutingAction, RouteView: View> where State.Route == Action.Route {
    let viewStore: ViewStore<State, Action>
    let routePathBinding: Binding<IdentifiedArrayOf<State.Route>>
    let content: (State.Route.ID) -> IfLetStore<State.Route, State.Route.Action, RouteView?>

    init(
        routePathBinding: Binding<IdentifiedArrayOf<State.Route>>,
        viewStore: ViewStore<State, Action>,
        content: @escaping (State.Route.ID) -> IfLetStore<State.Route, State.Route.Action, RouteView?>
    ) {
        self.routePathBinding = routePathBinding
        self.viewStore = viewStore
        self.content = content
    }

    @available(iOS 16, *)
    func navigationPathBinding() -> Binding<NavigationPath> {
        .init(
            get: {
                .init(self.routePathBinding.map(\.id))
            }, set: {
                self.viewStore.send(.navigation(._updateNavigationPath($0)))
            }
        )
    }
}

public final class Modal<Route: Routing, RouteView: View> {
    public let item: Binding<Route?>
    public let content: (Route) -> IfLetStore<Route, Route.Action, RouteView?>

    init(
        item: Binding<Route?>,
        content: @escaping (Route) -> IfLetStore<Route, Route.Action, RouteView?>
    ) {
        self.item = item
        self.content = content
    }
}

/// A view that unwraps a store holding a ``RoutingReducerProtocol`` and allows you to build a custom navigation structure.
///
/// You will always receive the `rootStore`, which should be passed to your root view,
/// a navigation state and a modal state. You can use these states to build your custom presentation
/// logic, as long as you have an item-based presentation modifier.
///
/// Usage:
/// ```
/// WithRoutingStore(store) { rootStore, navigation, modal in
///     NavigationStackWithStore(
///         navigation: navigation,
///         rootView: { LandingView(store: rootStore) }
///     )
///     .sheet(item: modal.item, content: modal.content)
/// } routes: { store in
///     SwitchStore(store) {
///         CaseLet(
///             state: /LandingRouter.Route.first,
///             action: LandingRouter.Route.Action.first,
///             then: FirstView.init
///         )
///         CaseLet(
///             state: /LandingRouter.Route.second,
///             action: LandingRouter.Route.Action.second,
///             then: SecondView.init
///         )
///         CaseLet(
///             state: /LandingRouter.Route.modalRouter,
///             action: LandingRouter.Route.Action.modalRouter,
///             then: ModalRouterView.init
///         )
///     }
/// }
/// ```
public struct WithRoutingStore<
    State: RoutingState,
    Action: RoutingAction,
    ResultView: View,
    RouteView: View
>: View where State.Route == Action.Route {
    let store: Store<State, Action>
    let content: ContentBuilder
    let routes: (Store<State.Route, State.Route.Action>) -> RouteView

    public typealias ContentBuilder = (
        Store<State.RootState, Action.RootAction>,
        Navigation<State, Action, RouteView>,
        Modal<State.Route, RouteView>
    ) -> ResultView

    public init(
        _ store: Store<State, Action>,
        content: @escaping ContentBuilder,
        routes: @escaping (Store<State.Route, State.Route.Action>) -> RouteView
    ) {
        self.store = store
        self.content = content
        self.routes = routes
    }

    public var body: some View {
        WithViewStore(store) { vs in
            content(
                store.scope(state: \.root, action: Action.root),
                .init(
                    routePathBinding: ViewStore(store.navigationStore).binding(\.$routePath),
                    viewStore: vs
                ) { id in
                    IfLetStore(
                        store.scope(
                            state: replayNonNil({ $0.navigation.routePath[id: id] }),
                            action: { Action.route(id, $0) }
                        ),
                        then: routes
                    )
                },
                .init(item: ViewStore(store.navigationStore).binding(\.$currentModal)) { item in
                    IfLetStore(
                        store.scope(
                            state: replayNonNil({ _ in item }),
                            action: Action.modalRoute
                        ),
                        then: routes
                    )
                }
            )
        }
    }
}


