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

struct _NavigationControllerWithStore<
    Reducer: RoutingReducerProtocol,
    Root: View,
    Route: View
>: UIViewControllerRepresentable {
    typealias RootState = Reducer.State.RootState
    typealias RootAction = Reducer.Action.RootAction
    typealias RouteState = Reducer.Action.Route
    typealias RouteAction = Reducer.Action.Route.RouteAction

    @Binding var routePath: IdentifiedArrayOf<Reducer.Route>
    let rootView: Root
    let viewForRoute: (Reducer.Route) -> Route

    init(
        routePath: Binding<IdentifiedArrayOf<Reducer.Route>>,
        rootView: Root,
        @ViewBuilder viewForRoute: @escaping (Reducer.Route) -> Route
    ) {
        _routePath = routePath
        self.rootView = rootView
        self.viewForRoute = viewForRoute
    }

    func makeUIViewController(context: Context) -> _UINavigationControllerWithRoutePath {
        let nc = _UINavigationControllerWithRoutePath(rootViewController: UIHostingController(rootView: rootView))
        nc.delegate = context.coordinator
        nc.routePathIds = routePath.map(\.id).map(AnyHashable.init)
        return nc
    }

    func updateUIViewController(_ uiViewController: _UINavigationControllerWithRoutePath, context: Context) {
        updateNavigationController(uiViewController)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator { nc, index in
            nc.popToViewControllerAt(
                index,
                animated: true,
                skipSuper: true
            )

            routePath.removeLast(routePath.count - index)
        }
    }

    func updateNavigationController(_ navigationController: _UINavigationControllerWithRoutePath) {
        let viewState = routePath.map(\.id).map(AnyHashable.init)
        let controllerState = navigationController.routePathIds

        guard viewState != controllerState else {
            return
        }

        if viewState.count > controllerState.count {
            for i in controllerState.count..<viewState.count {
                guard let routeId = viewState[i].base as? Reducer.Route.ID,
                      let route = routePath[id: routeId]
                else {
                    continue
                }

                navigationController.pushViewController(
                    UIHostingController(
                        rootView: viewForRoute(route)
                    ),
                    animated: true,
                    routeId: routeId
                )
            }
        } else {
            navigationController.popToViewControllerAt(
                viewState.count,
                animated: true
            )
        }
    }
}

// MARK: - Private resolutions

extension _NavigationControllerWithStore {
    final class Coordinator: NSObject, UINavigationControllerDelegate {
        var onPopToIndex: (_UINavigationControllerWithRoutePath, Int) -> Void

        init(onPopToIndex: @escaping (_UINavigationControllerWithRoutePath, Int) -> Void) {
            self.onPopToIndex = onPopToIndex
        }

        func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
            guard let nc = navigationController as? _UINavigationControllerWithRoutePath else { return }

                let isPopping = (nc.viewControllers.count - 1) < nc.routePathIds.count
                if isPopping {
                    self.onPopToIndex(nc, nc.viewControllers.count - 1)
                }
        }
    }
}
