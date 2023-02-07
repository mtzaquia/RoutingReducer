//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture

public struct NavigationState<Route: NavigationRoute>: Equatable {
    public var navigation: Route.NavigationState
    var root: Route.RootReducer.State

    public init(
        navigation: Route.NavigationState = .init(),
        root: Route.RootReducer.State
    ) {
        self.navigation = navigation
        self.root = root
    }
}


