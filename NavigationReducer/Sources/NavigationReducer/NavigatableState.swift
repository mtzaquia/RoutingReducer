//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture

public struct NavigationState<
    Destination: NavigationDestination,
    RootReducer: ReducerProtocol
>: Equatable where RootReducer.State: Equatable {
    public var navigation: Destination.NavigationState
    var root: RootReducer.State

    public init(
        navigation: Destination.NavigationState = .init(),
        root: RootReducer.State
    ) {
        self.navigation = navigation
        self.root = root
    }
}


