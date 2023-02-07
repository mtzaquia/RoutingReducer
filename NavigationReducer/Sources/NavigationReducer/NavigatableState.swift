//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture

public protocol RoutingState: Equatable {
    associatedtype Route: Routing
    var navigation: _RoutingReducer<Route>.State { get set }
}

public protocol RoutedState: Equatable, Hashable, Identifiable {}
