//
//  Copyright (c) 2023 @mtzaquia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit
import SwiftUI
import ComposableArchitecture

/// A view capable of handling navigation described in a ``RoutingReducerProtocol``.
///
/// This backwards-compatible view uses a `UIViewControllerRepresentable` to
/// mimic API improvements made with `NavigationStack`. For iOS 16 and above, see ``NavigationStackWithStore`` instead.
///
/// Usage:
/// ```
/// NavigationControllerWithStore<SomeRouter, _, _>(
///     store: store,
///     rootView: RootView.init
/// ) { store in
///     SwitchStore(store) {
///         CaseLet(
///             state: /SomeRouter.Route.first,
///             action: SomeRouter.Route.Action.first,
///             then: FirstView.init
///         )
///         CaseLet(
///             state: /LandingRouter.Route.modalRouter,
///             action: LandingRouter.Route.Action.modalRouter,
///             then: ModalRouterView.init
///         )
///     }
/// }
/// ```
@available(iOS, obsoleted: 16, renamed: "NavigationStackWithStore")
public struct NavigationControllerWithStore<
    Reducer: RoutingReducerProtocol,
    Root: View,
    Route: View
>: View {
    public typealias RootState = Reducer.State.RootState
    public typealias RootAction = Reducer.Action.RootAction
    public typealias RouteState = Reducer.Action.Route
    public typealias RouteAction = Reducer.Action.Route.Action

    let store: StoreOf<Reducer>
    let rootView: Root
    let routeViews: (Store<RouteState, RouteAction>) -> Route

    /// Creates a new instance of ``NavigationControllerWithStore``.
    ///
    /// - Parameters:
    ///   - store: The `Store` of a reducer conforming to ``RoutingReducerProtocol``.
    ///   - rootView: The root `SwiftUI.View` for this flow.
    ///   - routeViews: A `SwitchStore` with `CaseLet` views for every possible route
    ///   described in your routes for this flow.
    public init(
        store: StoreOf<Reducer>,
        @ViewBuilder rootView: (Store<RootState, RootAction>) -> Root,
        @ViewBuilder routeViews: @escaping (Store<RouteState, RouteAction>) -> Route
    ) {
        self.store = store
        self.rootView = rootView(
            store.scope(
                state: \.root,
                action: Reducer.Action.root
            )
        )
        self.routeViews = routeViews
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            _NavigationControllerWithStore<Reducer, _, _>(
                routePath: ViewStore(
                    store.scope(
                        state: \.navigation,
                        action: Reducer.Action.navigation
                    )
                ).binding(\.$routePath),
                rootView: rootView,
                viewForRoute: { route in
                    IfLetStore(
                        store.scope(
                            state: replayNonNil({ $0.navigation.routePath.first(where: { $0.id == route.id }) }),
                            action: { Reducer.Action.route(route.id, $0) }
                        ),
                        then: routeViews
                    )
                }
            )
            .ignoresSafeArea()
            .sheet(
                isPresented: .init(
                    get: { viewStore.state.navigation.currentModal != nil },
                    set: {
                        if !$0 {
                            viewStore.send(.navigation(.dismiss))
                        }
                    }
                )
            ) {
                IfLetStore(
                    store.scope(
                        state: replayNonNil(\.navigation.currentModal),
                        action: Reducer.Action.modalRoute
                    ),
                    then: routeViews
                )
            }
        }
    }
}
