//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

/// A wrapper for a navigations stack state.
///
/// Instances of this wrapper are acquired via declarations of ``WithRoutingStore``
/// and should be provided to a ``RoutedNavigationStack`` instance.
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
