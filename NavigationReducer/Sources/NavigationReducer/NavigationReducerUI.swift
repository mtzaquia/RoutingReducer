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
                .navigationDestination(for: NavigationReducer.Destination.self) { path in
                    navigationView(path)
                }
            }
            .sheet(
                isPresented: .init(get: {
                    viewStore.navigation.currentModal != nil
                }, set: {
                    if !$0 {
                        viewStore.send(.navigation(.dismiss))
                    }
                })
            ) {
                modalView(viewStore.navigation.currentModal!)
            }
        }
    }
}

// MARK: - Private resolutions

private extension NavigationReducerUI {
    func modalView(_ path: NavigationReducer.Destination) -> some View {
        IfLetStore(
            store.scope(
                state: \.navigation.currentModal,
                action: { NavigationReducer.Action.destination(path.id, $0) }
            ),
            then: NavigationReducer.destinationSwitchStore
        )
    }

    func navigationView(_ path: NavigationReducer.Destination) -> some View {
        IfLetStore(
            store.scope(
                state: { _ in path },
                action: { NavigationReducer.Action.destination(path.id, $0) }
            ),
            then: NavigationReducer.destinationSwitchStore
        )
    }
}
