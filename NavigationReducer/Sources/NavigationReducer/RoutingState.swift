//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture

public protocol RoutingState: Equatable, Hashable {
    associatedtype Route: Routing
    associatedtype RootState: RoutedState

    var navigation: Route.NavigationState { get set }
    var root: RootState { get set }
}
