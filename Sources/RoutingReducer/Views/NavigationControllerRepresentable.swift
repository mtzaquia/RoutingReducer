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

/// A representable for supporting iOS 16's `NavigationStack` capabilities on iOS 15.
///
/// Usage:
/// ```
/// NavigationControllerRepresentable(
///     navigationPath: $navigationPath,
///     barAppearance: someBarAppearance
/// ) {
///     /* your root view */
/// } navigationDestination: { id in
///     /* your navigation destination for the given ID */
/// }
/// ```
public struct NavigationControllerRepresentable<
    Segment: Identifiable,
    RootView: View,
    RouteView: View
>: View {
    @Binding var navigationPath: IdentifiedArrayOf<Segment>
    let barAppearance: UINavigationBarAppearance?
    let rootView: () -> RootView
    let navigationDestination: (Segment.ID) -> RouteView

    public init(
        navigationPath: Binding<IdentifiedArrayOf<Segment>>,
        barAppearance: UINavigationBarAppearance? = nil,
        @ViewBuilder rootView: @escaping () -> RootView,
        @ViewBuilder navigationDestination: @escaping (Segment.ID) -> RouteView
    ) {
        _navigationPath = navigationPath
        self.barAppearance = barAppearance
        self.rootView = rootView
        self.navigationDestination = navigationDestination
    }

    public var body: some View {
        _NavigationControllerRepresentable(
            navigationPath: $navigationPath,
            barAppearance: barAppearance,
            rootView: rootView,
            navigationDestination: navigationDestination
        )
        .ignoresSafeArea()
    }
}

public struct _NeverIdentifiable: Identifiable {
    public var id: Int { 0 }
}

public extension NavigationControllerRepresentable
where Segment == _NeverIdentifiable, RouteView == EmptyView {
    init(
        barAppearance: UINavigationBarAppearance? = nil,
        @ViewBuilder rootView: @escaping () -> RootView
    ) {
        _navigationPath = .constant(.init())
        self.barAppearance = barAppearance
        self.rootView = rootView
        self.navigationDestination = { _ in EmptyView() }
    }
}

struct _NavigationControllerRepresentable<
    Segment: Identifiable,
    RootView: View,
    RouteView: View
>: UIViewControllerRepresentable {
    @Binding var navigationPath: IdentifiedArrayOf<Segment>
    let barAppearance: UINavigationBarAppearance?
    let rootView: RootView
    let navigationDestination: (Segment.ID) -> RouteView

    init(
        navigationPath: Binding<IdentifiedArrayOf<Segment>>,
        barAppearance: UINavigationBarAppearance? = nil,
        @ViewBuilder rootView: () -> RootView,
        @ViewBuilder navigationDestination: @escaping (Segment.ID) -> RouteView
    ) {
        _navigationPath = navigationPath
        self.barAppearance = barAppearance
        self.rootView = rootView()
        self.navigationDestination = navigationDestination
    }

    func makeUIViewController(context: Context) -> _UINavigationControllerWithRoutePath {
        let nc = _UINavigationControllerWithRoutePath()
        nc.delegate = context.coordinator

        nc.navigationBar.prefersLargeTitles = true

        nc.routePathIds = navigationPath.map(\.id).map(AnyHashable.init)
        nc.viewControllers = [UIHostingController(rootView: rootView)] + navigationPath.map { UIHostingController(rootView: navigationDestination($0.id)) }
        updateBarAppearance(for: nc)
        return nc
    }

    func updateUIViewController(_ uiViewController: _UINavigationControllerWithRoutePath, context: Context) {
        updateNavigationController(uiViewController)
        updateBarAppearance(for: uiViewController)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator { nc, index in
            nc.popToViewControllerAt(
                index,
                animated: true,
                skipSuper: true
            )

            navigationPath.removeLast(navigationPath.count - index)
        }
    }

    func updateNavigationController(_ navigationController: _UINavigationControllerWithRoutePath) {
        let viewState = navigationPath.map(\.id).map(AnyHashable.init)
        let controllerState = navigationController.routePathIds

        guard viewState != controllerState else {
            return
        }

        if viewState.count > controllerState.count {
            for i in controllerState.count..<viewState.count {
                guard let routeId = viewState[i].base as? Segment.ID,
                      let route = navigationPath[id: routeId]
                else {
                    continue
                }

                let pushingController = UIHostingController(rootView: navigationDestination(route.id))
                // ensures navigationItem properties are evaluated
                // before the pushing animation starts.
                pushingController._render(seconds: 0)

                navigationController.pushViewController(
                    pushingController,
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

    private func updateBarAppearance(for navigationController: UINavigationController) {
        let bar = navigationController.navigationBar

        defer { bar.setNeedsLayout() }

        guard let barAppearance else { return }

        bar.compactAppearance = barAppearance
        bar.standardAppearance = barAppearance
        bar.scrollEdgeAppearance = barAppearance
        bar.compactScrollEdgeAppearance = barAppearance
    }
}

// MARK: - Coordinator

extension _NavigationControllerRepresentable {
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
