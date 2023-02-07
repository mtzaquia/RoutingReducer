//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture

public protocol Routing: Equatable, Hashable, Identifiable {
    typealias NavigationState = _RoutingReducer<Self>.State
    typealias NavigationAction = _RoutingReducer<Self>.Action

    associatedtype RouteAction
}

