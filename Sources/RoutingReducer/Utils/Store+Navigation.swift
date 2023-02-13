//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture

extension Store where State: RoutingState, Action: RoutingAction {
    var navigationStore: Store<State.Route.NavigationState, Action.Route.NavigationAction> {
        scope(
            state: \.navigation,
            action: Action.navigation
        )
    }
}
