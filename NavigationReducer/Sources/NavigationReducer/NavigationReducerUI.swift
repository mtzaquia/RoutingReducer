//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct NavigationReducerUI<NavigationReducer>: View where NavigationReducer: NavigationReducerProtocol {
    public init(store: StoreOf<NavigationReducer>) {
        self.store = store
    }

    public let store: StoreOf<NavigationReducer>
    public var body: some View {
        WithViewStore(store) { viewStore in
            NavigationStack(
                path: ViewStore(
                    store.scope(
                        state: \.navigation,
                        action: NavigationReducer.Action.navigation
                    )
                ).binding(\.$navigationPath)
            ) {
                NavigationReducer.rootView(
                    store: store.scope(
                        state: \.root,
                        action: NavigationReducer.Action.root
                    )
                )
                .navigationDestination(
                    for: NavigationReducer.Route.ID.self,
                    destination: navigationView(id:)
                )
            }
//            .sheet(
//                isPresented: .init(get: {
//                    viewStore.navigation.currentModal != nil
//                }, set: {
//                    if !$0 {
//                        viewStore.send(.navigation(.dismiss))
//                    }
//                })
//            ) {
//                modalView(viewStore.navigation.currentModal!)
//            }
        }
    }
}

// MARK: - Private resolutions

private extension NavigationReducerUI {
//    func modalView(_ path: NavigationReducer.Route) -> some View {
//        IfLetStore(
//            store.scope(
//                state: \.navigation.currentModal,
//                action: { NavigationReducer.Action.destination(path.id, $0) }
//            ),
//            then: NavigationReducer.destinationSwitchStore
//        )
//    }

    func navigationView(id: NavigationReducer.Route.ID) -> some View {
        IfLetStore(
            store.scope(
                state: { $0.navigation.routePath.first(where: { $0.id == id }) },
                action: { NavigationReducer.Action.route(id, $0) }
            ),
            then: NavigationReducer.destinationSwitchStore
        )
    }
}
