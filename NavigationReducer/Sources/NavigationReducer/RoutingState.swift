//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture

public protocol RoutingState: Identifiable, Hashable, Equatable {
    associatedtype Route: Routing
    var navigation: Route.NavigationState { get set }
}
