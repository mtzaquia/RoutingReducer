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

/// A wrapper for a navigations stack state.
///
/// Instances of this wrapper are acquired via declarations of ``WithRoutingStore``
/// and should be provided to a ``RoutedNavigationStack`` instance.
public final class Navigation<State: RoutingState, Action: RoutingAction, RouteView: View> where State.Route == Action.Route {
    let viewStore: ViewStore<State, Action>
    let routePathBinding: Binding<IdentifiedArrayOf<State.Route>>
    let content: (State.Route.ID) -> IfLetStore<State.Route, State.Route.Action, RouteView?>

    init(
        routePathBinding: Binding<IdentifiedArrayOf<State.Route>>,
        viewStore: ViewStore<State, Action>,
        content: @escaping (State.Route.ID) -> IfLetStore<State.Route, State.Route.Action, RouteView?>
    ) {
        self.routePathBinding = routePathBinding
        self.viewStore = viewStore
        self.content = content
    }

    @available(iOS 16, *)
    func navigationPathBinding() -> Binding<NavigationPath> {
        .init(
            get: {
                .init(self.routePathBinding.map(\.id))
            }, set: {
                self.viewStore.send(.navigation(._updateNavigationPath($0)))
            }
        )
    }
}
