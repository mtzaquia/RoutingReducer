//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture

public enum NavigationAction<Destination: NavigationDestination> {
    case navigation(Destination.NavigationAction)
    case root(Destination.RootReducer.Action)
    // TODO: With an optional ID, BindingReducers do not work within destination reducers...
    case destination(Destination.ID, Destination.Action)
    // ... so how to accomplish this?
//    static func destinationModal(_ action: Destination.Action) -> Self { .destination(nil, action) }
}
