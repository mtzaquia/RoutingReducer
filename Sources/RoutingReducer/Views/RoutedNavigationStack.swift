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

import SwiftUI
import ComposableArchitecture

/// A view capable of handling navigation described in a ``RoutingReducerProtocol``.
///
/// This view uses a `NavigationStack` to manage a navigation and modals attached to it on iOS 16+,
/// and a representable wrapping a `UINavigationController` for iOS 15.
///
/// - On iOS 15, you may also provide an instance of `UINavigationBarAppearance` to customise your bar.
/// - On iOS 16, prefer using `.toolbar(...)` modifiers.
///
/// Usage:
/// ```
/// WithRoutingStore(store) { rootStore, navigation, _ in
///     RoutedNavigationStack(navigation: navigation) {
///         RootView(store: rootStore)
///     }
/// }
/// ```
public struct RoutedNavigationStack<
    State: RoutingState,
    Action: RoutingAction,
    RootView: View,
    RouteView: View
>: View where State.Route == Action.Route {
    let navigation: Navigation<State, Action, RouteView>
    let barAppearance: UINavigationBarAppearance?
    let rootView: RootView

    /// Creates a new instance of ``RoutedNavigationStack``.
    ///
    /// - Parameters:
    ///   - navigation: The `Presentation` instance extracted from a `Store` using ``WithRoutingStore``.
    ///   - rootView: The root `SwiftUI.View` for this flow.
    public init(
        navigation: Navigation<State, Action, RouteView>,
        @ViewBuilder rootView: @escaping () -> RootView
    ) {
        self.navigation = navigation
        self.barAppearance = nil
        self.rootView = rootView()
    }

    @available(iOS, obsoleted: 16, renamed: "init(navigation:rootView:)")
    /// Creates a new instance of ``RoutedNavigationStack`` with a custom bar appearance.
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
        if #available(iOS 16, *) {
            NavigationStack(
                path: navigation.navigationPathBinding()
            ) {
                rootView
                .navigationDestination(
                    for: State.Route.ID.self,
                    destination: navigation.content
                )
            }
        } else {
            _NavigationControllerRepresentable(
                routePath: navigation.routePathBinding,
                barAppearance: barAppearance,
                rootView: rootView,
                viewForRoute: navigation.content
            )
            .ignoresSafeArea()
        }
    }
}
