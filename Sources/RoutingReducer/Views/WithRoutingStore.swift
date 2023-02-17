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

import ComposableArchitecture
import SwiftUI

/// A view that unwraps a store holding a ``RoutingReducerProtocol`` and allows you to build a custom navigation structure.
///
/// You will always receive the `rootStore`, which should be passed to your root view,
/// a navigation state and a modal state. You can use these states to build your custom presentation
/// logic, as long as you have an item-based presentation modifier.
///
/// Usage:
/// ```
/// WithRoutingStore(store) { rootStore, navigation, modal in
///     RoutedNavigationStack(
///         navigation: navigation,
///         rootView: { LandingView(store: rootStore) }
///     )
///     .sheet(item: modal.item, content: modal.content)
/// } routes: { store in
///     SwitchStore(store) {
///         CaseLet(
///             state: /LandingRouter.Route.first,
///             action: LandingRouter.Route.Action.first,
///             then: FirstView.init
///         )
///         CaseLet(
///             state: /LandingRouter.Route.second,
///             action: LandingRouter.Route.Action.second,
///             then: SecondView.init
///         )
///         CaseLet(
///             state: /LandingRouter.Route.modalRouter,
///             action: LandingRouter.Route.Action.modalRouter,
///             then: ModalRouterView.init
///         )
///     }
/// }
/// ```
public struct WithRoutingStore<
    State: RoutingState,
    Action: RoutingAction,
    ResultView: View,
    CaseLetView: View
>: View where State.Route == Action.Route {

    public typealias RootSwitch = SwitchStore<State.Route, State.Route.Action, CaseLetView>

    let store: Store<State, Action>
    let content: ContentBuilder
    let routes: (Store<State.Route, State.Route.Action>) -> RootSwitch

    public typealias ContentBuilder = (
        _ rootStore: Store<State.RootState, Action.RootAction>,
        _ navigation: Navigation<State, Action, RootSwitch>,
        _ modal: Modal<State.Route, RootSwitch>
    ) -> ResultView

    /// Builds a new instance of ``WithRoutingStore``.
    ///
    /// ```swift
    /// WithRoutingStore(store) { rootStore, navigation, modal in
    ///     ...
    /// } routes: { store in
    ///     SwitchStore(store) {
    ///         ...
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - store: The store of a ``RoutingState`` and a ``RoutingAction``,
    ///   also representable as `StoreOf<R: RoutingReducerProtocol>`.
    ///   - content: The base view and all of its attachments. You can use the
    ///   `rootStore`, `navigation` and `modal` parameters provided as input to this closure
    ///   to build your presentation strategy.
    ///   - routes: A `SwitchStore` view for all possible routes from the `Store`'s reducer.
    public init(
        _ store: Store<State, Action>,
        content: @escaping ContentBuilder,
        routes: @escaping (Store<State.Route, State.Route.Action>) -> RootSwitch
    ) {
        self.store = store
        self.content = content
        self.routes = routes
    }

    public var body: some View {
        WithViewStore(store) { vs in
            content(
                store.scope(state: \.root, action: Action.root),
                .init(
                    routePathBinding: ViewStore(store.navigationStore).binding(\.$routePath),
                    viewStore: vs
                ) { id in
                    IfLetStore(
                        store.scope(
                            state: replayNonNil({ $0.navigation.routePath[id: id] }),
                            action: { Action.route(id, $0) }
                        ),
                        then: routes
                    )
                },
                .init(
                    item: ViewStore(store.navigationStore).binding(\.$currentModal)
                ) { item in
                    IfLetStore(
                        store.scope(
                            state: replayNonNil({ _ in item }),
                            action: Action.modalRoute
                        ),
                        then: routes
                    )
                }
            )
        }
    }
}


