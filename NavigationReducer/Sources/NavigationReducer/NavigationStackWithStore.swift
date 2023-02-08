//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public protocol RoutingReducerProtocol: ReducerProtocol
where State: RoutingState, Action: RoutingAction, State.Route == Action.Route {}

public struct NavigationStackWithStore<Reducer: RoutingReducerProtocol, Root: View, Route: View>: View {
    let store: StoreOf<Reducer>
    let rootView: Root
    let routeViews: (Store<Reducer.Action.Route, Reducer.Action.Route.RouteAction>) -> Route

    public init(
        store: StoreOf<Reducer>,
        @ViewBuilder rootView: (Store<Reducer.State.RootState, Reducer.Action.RootAction>) -> Root,
        @ViewBuilder routeViews: @escaping (Store<Reducer.Action.Route, Reducer.Action.Route.RouteAction>) -> Route
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
                path: ViewStore(
                    store.scope(
                        state: \.navigation,
                        action: Reducer.Action.navigation
                    )
                ).binding(\.$navigationPath)
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

private func replayNonNil<A, B>(_ inputClosure: @escaping (A) -> B?) -> (A) -> B? {
  var lastNonNilOutput: B? = nil
  return { inputValue in
    guard let outputValue = inputClosure(inputValue) else {
      return lastNonNilOutput
    }
    lastNonNilOutput = outputValue
    return outputValue
  }
}
