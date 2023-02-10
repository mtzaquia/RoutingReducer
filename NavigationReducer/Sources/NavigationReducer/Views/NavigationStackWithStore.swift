//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

@available(iOS 16, *)
public struct NavigationStackWithStore<
    Reducer: RoutingReducerProtocol,
    Root: View,
    Route: View
>: View {
    public typealias RootState = Reducer.State.RootState
    public typealias RootAction = Reducer.Action.RootAction
    public typealias RouteState = Reducer.Action.Route
    public typealias RouteAction = Reducer.Action.Route.RouteAction

    let store: StoreOf<Reducer>
    let rootView: Root
    let routeViews: (Store<RouteState, RouteAction>) -> Route

    public init(
        store: StoreOf<Reducer>,
        @ViewBuilder rootView: (Store<RootState, RootAction>) -> Root,
        @ViewBuilder routeViews: @escaping (Store<RouteState, RouteAction>) -> Route
    ) {
        self.store = store
        self.rootView = rootView(
            store.scope(
                state: \.root,
                action: Reducer.Action.root
            )
        )
        self.routeViews = routeViews
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            NavigationStack(
                path: .init(
                    get: {
                        .init(viewStore.navigation.routePath.map(\.id))
                    }, set: {
                        viewStore.send(.navigation(._updateNavigationPath($0)))
                    }
                )
            ) {
                rootView
                .navigationDestination(
                    for: Reducer.State.Route.ID.self,
                    destination: navigationView(id:)
                )
            }
            .sheet(
                isPresented: .init(
                    get: { viewStore.state.navigation.currentModal != nil },
                    set: {
                        if !$0 {
                            viewStore.send(.navigation(.dismiss))
                        }
                    }
                )
            ) {
                IfLetStore(
                    store.scope(
                        state: replayNonNil(\.navigation.currentModal),
                        action: Reducer.Action.modalRoute
                    ),
                    then: routeViews
                )
            }
        }
    }
}

// MARK: - Private resolutions

@available(iOS 16, *)
private extension NavigationStackWithStore {
    func navigationView(id: Reducer.State.Route.ID) -> some View {
        IfLetStore(
            store.scope(
                state: replayNonNil({ $0.navigation.routePath.first(where: { $0.id == id }) }),
                action: { Reducer.Action.route(id, $0) }
            ),
            then: routeViews
        )
    }
}
