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

    func makeUIViewController(context: Context) -> UINavigationController {
        let nc = UINavigationController(rootViewController: UIHostingController(rootView: rootView))
        nc.delegate = context.coordinator
        nc.routePathIds = routePath.map(\.id).map(AnyHashable.init)
        return nc
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        let routePathIds = routePath.map(\.id).map(AnyHashable.init)
        guard routePathIds.count != uiViewController.routePathIds.count else {
            return
        }

        if routePathIds.count > uiViewController.routePathIds.count {
            for i in uiViewController.routePathIds.count..<routePathIds.count {
                guard let routeId = routePathIds[i].base as? Reducer.Route.ID,
                      let route = routePath[id: routeId]
                else {
                    continue
                }

                uiViewController.routePathIds.append(routeId)
                uiViewController.pushViewController(
                    UIHostingController(
                        rootView: viewForRoute(route)
                    ),
                    animated: true
                )
            }
        } else {
            uiViewController.popToViewController(
                uiViewController.viewControllers[routePathIds.count],
                animated: true
            )
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(routePath: $routePath)
    }
}

// MARK: - Private resolutions

extension _NavigationControllerWithStore {
    final class Coordinator: NSObject, UINavigationControllerDelegate {
        let routePath: Binding<IdentifiedArrayOf<Reducer.Route>>

        init(routePath: Binding<IdentifiedArrayOf<Reducer.Route>>) {
            self.routePath = routePath
        }

        func navigationController(
            _ navigationController: UINavigationController,
            animationControllerFor operation: UINavigationController.Operation,
            from fromVC: UIViewController,
            to toVC: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {
            guard operation == .pop else { return nil }

            let routePathIds = routePath.map(\.id).map(AnyHashable.init)
            let difference = navigationController.routePathIds.count - routePathIds.count
            navigationController.routePathIds.removeLast(difference)

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
