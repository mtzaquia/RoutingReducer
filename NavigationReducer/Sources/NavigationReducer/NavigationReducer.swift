//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import protocol SwiftUI.View
import ComposableArchitecture

public struct NavigationReducer<
    Destination: NavigationDestination,
    RootReducer: ReducerProtocol
>: ReducerProtocol where RootReducer.State: Equatable {
    public typealias State = NavigationState<Destination, RootReducer>
    public typealias Action = NavigationAction<Destination, RootReducer>

    public let rootReducer: RootReducer
    public let navigationHandler: (Action) -> Destination.NavigationAction?

    public init(
        rootReducer: RootReducer,
        navigationHandler: @escaping (Action) -> Destination.NavigationAction?
    ) {
        self.rootReducer = rootReducer
        self.navigationHandler = navigationHandler
    }

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            guard let action = navigationHandler(action) else {
                return .none
            }

            return .task { .navigation(action) }
        }
        Scope(state: \.navigation, action: /Action.navigation) {
            _NavigationReducer<Destination>()
        }
        Scope(state: \.root, action: /Action.root) {
            rootReducer
        }
    }
}

public protocol NavigationReducerProtocol: ReducerProtocol
where State == NavigationState<Destination, RootReducer>,
      Action == NavigationAction<Destination, RootReducer> {
    associatedtype Destination: NavigationDestination
    associatedtype RootReducer: ReducerProtocol where RootReducer.State: Equatable

    associatedtype RootView: View
    associatedtype SwitchView: View

    static func rootView(store: StoreOf<RootReducer>) -> RootView
    static func destinationSwitchStore(
        store: Store<Destination, Destination.Action>
    ) -> SwitchView
}
