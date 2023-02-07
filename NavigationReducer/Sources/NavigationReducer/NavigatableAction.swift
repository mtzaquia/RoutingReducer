//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture

public protocol RoutingAction {
    associatedtype Route: Routing
    static func navigation(_ action: _RoutingReducer<Route>.Action) -> Self
    static func route(_ id: Route.ID, _ action: Route.Action) -> Self
}
