//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import protocol SwiftUI.View
import ComposableArchitecture

public struct NavigationReducer<
    Destination: NavigationDestination
>: ReducerProtocol {
    public typealias State = NavigationState<Destination>
    public typealias Action = NavigationAction<Destination>

    public let rootReducer: Destination.RootReducer
    public let navigationHandler: (Action) -> Destination.NavigationAction?

    public init(
        rootReducer: Destination.RootReducer,
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
            _NavigationReducer()
        }
        Scope(state: \.root, action: /Action.root) {
            rootReducer
        }
    }
}

public protocol NavigationReducerProtocol: ReducerProtocol
where State == NavigationState<Destination>,
      Action == NavigationAction<Destination> {
    associatedtype Destination: NavigationDestination

//    associatedtype IfLetReducer: ReducerProtocol<Destination?, Destination.Action>
//    @ReducerBuilder<Destination?, Destination.Action>
//    func ifCaseLetReducer(_ baseReducer: EmptyReducer<Destination?, Destination.Action>) -> IfLetReducer

    associatedtype ForEachReducer: ReducerProtocol<Destination, Destination.Action>
    @ReducerBuilder<Destination, Destination.Action>
    var forEachReducers: ForEachReducer { get }

    func handleNavigation(_ action: NavigationAction<Destination>) -> Destination.NavigationAction?
    var rootReducer: Destination.RootReducer { get }

    associatedtype RootView: View
    associatedtype SwitchView: View

    static func rootView(store: StoreOf<Destination.RootReducer>) -> RootView
    static func destinationSwitchStore(
        store: Store<Destination, Destination.Action>
    ) -> SwitchView
}

public extension NavigationReducerProtocol {
    @ReducerBuilder<State, Action>
    var body: some ReducerProtocol<State, Action> {
//        Scope(state: \.navigation.currentModal, action: /Action.destinationModal) { ifCaseLetReducer(EmptyReducer()) }
        NavigationReducer(rootReducer: rootReducer, navigationHandler: handleNavigation)
            .forEach(\.navigation.destinationPath, action: /Action.destination) { forEachReducers }
    }
}
