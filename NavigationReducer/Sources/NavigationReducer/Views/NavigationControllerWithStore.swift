//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import UIKit
import SwiftUI
import ComposableArchitecture

public struct NavigationControllerWithStore<
    Reducer: RoutingReducerProtocol,
    Root: View,
    Route: View
>: View {
    public typealias RootState = Reducer.State.RootState
    public typealias RootAction = Reducer.Action.RootAction
    public typealias RouteState = Reducer.Action.Route
    public typealias RouteAction = Reducer.Action.Route.RouteAction

    let store: StoreOf<Reducer>
    let rootView: Root
    let routeViews: (Store<RouteState, RouteAction>) -> Route

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

private struct _NavigationControllerWithStore<
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

            let adjustedIndex = index - 1 // routePath is 0 based, viewControllers is 1 based (there's always a root)
            routePath.removeLast(routePath.count - adjustedIndex)
        }
    }

    func updateNavigationController(_ navigationController: _UINavigationControllerWithRoutePath) {
        let viewState = routePath.map(\.id).map(AnyHashable.init)
        let controllerState = navigationController.routePathIds

        guard viewState != controllerState else {
            return
        }

        print("view", viewState)

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

        print("nav", navigationController.routePathIds)
    }
}

// MARK: - Private resolutions

private final class _UINavigationControllerWithRoutePath: UINavigationController {
    func pushViewController(_ viewController: UIViewController, animated: Bool, routeId: AnyHashable) {
        routePathIds.append(routeId)

        let oldDelegate = delegate
        delegate = nil
        super.pushViewController(viewController, animated: animated)
        delegate = oldDelegate
    }

    @discardableResult
    func popToViewControllerAt(_ index: Int, animated: Bool, skipSuper: Bool = false) -> [UIViewController]? {
        let difference = routePathIds.count - index

        let oldDelegate = delegate
        delegate = nil

        defer {
            delegate = oldDelegate
            routePathIds.removeLast(difference)
        }

        if !skipSuper {
            return super.popToViewController(
                viewControllers[index],
                animated: true
            )
        } else {
            return nil
        }
    }
}

extension _NavigationControllerWithStore {
    final class Coordinator: NSObject, UINavigationControllerDelegate {
        var onPopToIndex: (_UINavigationControllerWithRoutePath, Int) -> Void

        init(onPopToIndex: @escaping (_UINavigationControllerWithRoutePath, Int) -> Void) {
            self.onPopToIndex = onPopToIndex
        }

        func navigationController(
            _ navigationController: UINavigationController,
            animationControllerFor operation: UINavigationController.Operation,
            from fromVC: UIViewController,
            to toVC: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {
            guard let nc = navigationController as? _UINavigationControllerWithRoutePath
            else { return nil }

            DispatchQueue.main.asyncAfter(deadline: .now()) {
                switch operation {
                    case .pop:
                        self.onPopToIndex(nc, nc.viewControllers.count)
                    default: break
                }
            }

            return nil
        }
    }
}

private var routePathIdsKey: Void?
extension UINavigationController {
    var routePathIds: [AnyHashable] {
        get {
            return objc_getAssociatedObject(self, &routePathIdsKey) as? [AnyHashable] ?? []
        }
        set {
            objc_setAssociatedObject(self, &routePathIdsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
