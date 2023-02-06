//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture

public enum NavigationAction<Destination: NavigationDestination, RootReducer: ReducerProtocol> {
    case navigation(Destination.NavigationAction)
    case root(RootReducer.Action)
    case destination(Destination.ID, Destination.Action)
    case destination2(Destination.Action)
}
