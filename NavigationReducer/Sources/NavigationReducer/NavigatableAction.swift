//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture

public enum NavigationAction<Route: NavigationRoute> {
    case navigation(Route.NavigationAction)
    case root(Route.RootReducer.Action)
    // TODO: With an optional ID, BindingReducers do not work within destination reducers...
    case route(Route.ID, Route.Action)
    // ... so how to accomplish this?
//    static func destinationModal(_ action: Route.Action) -> Self { .destination(nil, action) }
}
