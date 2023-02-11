//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture

/// A typealias for your root reducer.
/// Usually the returned type from your ``rootBody`` implementation.
///
/// Usage:
/// ```
/// var rootBody: some RootReducer<Self> { ... }
/// ```
public typealias RootReducer<
    RR: RoutingReducerProtocol
> = ReducerProtocol<
    RR.State.RootState,
    RR.Action.RootAction
>

/// A typealias for your route reducer.
/// Usually the returned type from your ``routeBody`` implementation.
///
/// Usage:
/// ```
/// var routeBody: some RouteReducer<Self> { ... }
/// ```
public typealias RouteReducer<
    RR: RoutingReducerProtocol
> = ReducerProtocol<
    RR.Route,
    RR.Route.Action
>
