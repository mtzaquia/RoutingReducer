//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture

public enum NavigationAction<Destination: NavigationDestination> {
    case navigation(Destination.NavigationAction)
    case root(Destination.RootReducer.Action)
    case destination(Destination.ID?, Destination.Action)

//    static func destinationModal(_ action: Destination.Action) -> Self { .destination(nil, action) }
}
