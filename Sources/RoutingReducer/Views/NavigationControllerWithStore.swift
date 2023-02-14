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
/// NavigationControllerWithStore(
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
    State: RoutingState,
    Action: RoutingAction,
    RootView: View,
    RouteView: View
>: View where State.Route == Action.Route {
    let navigation: Navigation<State, Action, RouteView>
    let barAppearance: UINavigationBarAppearance?
    let rootView: RootView

    /// Creates a new instance of ``NavigationControllerWithStore``.
    ///
    /// - Parameters:
    ///   - navigation: The `Presentation` instance extracted from a `Store` using ``WithRoutingStore``(...) { ... }`.
    ///   - barAppearance: An instance of `UINavigationBarAppearance` used to customise the
    ///   `UINavigationBar` wrapped by this representable.
    ///   - rootView: The root `SwiftUI.View` for this flow.
    public init(
        navigation: Navigation<State, Action, RouteView>,
        barAppearance: UINavigationBarAppearance? = nil,
        @ViewBuilder rootView: @escaping () -> RootView
    ) {
        self.navigation = navigation
        self.barAppearance = barAppearance
        self.rootView = rootView()
    }

    public var body: some View {
        _NavigationControllerWithStore(
            routePath: navigation.routePathBinding,
            barAppearance: barAppearance,
            rootView: rootView,
            viewForRoute: navigation.content
        )
        .ignoresSafeArea()
    }
}
