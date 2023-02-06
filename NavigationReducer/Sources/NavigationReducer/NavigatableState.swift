//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture

public struct NavigationState<Destination: NavigationDestination>: Equatable {
    public var navigation: Destination.NavigationState
    var root: Destination.RootReducer.State

    public init(
        navigation: Destination.NavigationState = .init(),
        root: Destination.RootReducer.State
    ) {
        self.navigation = navigation
        self.root = root
    }
}


