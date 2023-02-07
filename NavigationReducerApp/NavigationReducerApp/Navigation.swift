//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture
import NavigationReducer
import SwiftUI

enum AppRoute: Routing {
    case first(First.State)
    case second(Second.State)

    enum Action {
        case first(First.Action)
        case second(Second.Action)
    }

    var id: UUID {
        switch self {
            case .first(let state): return state.id
            case .second(let state): return state.id
        }
    }
}

//enum AppRoute: NavigationRoute {
//    typealias RootReducer = Landing
//
//    enum Action {
//        case first(First.Action)
//        case second(Second.Action)
//    }
//
//    case first(First.State)
//    case second(Second.State)
//
//    // TODO: how to move this to state, so that the same "destination" could be pushed twice with diff state
//    var id: String {
//        switch self {
//            case .first: return "first"
//            case .second: return "second"
//        }
//    }
//}
//
//struct AppNavigation: NavigationReducerProtocol {
//    typealias Route = AppRoute
//
//    func handleNavigation(_ action: NavigationAction<AppRoute>) -> AppRoute.NavigationAction? {
//        switch action {
//            case .root(.pushFirst): return .push(.first(First.State()))
////            case .root(.present): return .present(.first(.init()))
//            case .route(_, .first(.pushSecond)): return .push(.second(Second.State()))
//            case .route(_, .first(.popToLanding)): return .pop()
////            case .destination(_, .first(.present)): return .present(.second(.init()))
////            case .destination(_, .first(.dismiss)): return .dismiss
//            case .route(_, .second(.popToFirst)): return .pop()
//            case .route(_, .second(.popToRoot)): return .pop(toRoot: true)
////            case .destination(_, .second(.dismiss)): return .dismiss
//            default: break
//        }
//
//        return nil
//    }
//
//    var rootReducer = Landing()
//
////    func ifCaseLetReducer(
////        _ baseReducer: EmptyReducer<Route?, Route.Action>
////    ) -> some ReducerProtocol<Route?, Route.Action> {
////        baseReducer
////            .ifCaseLet(
////                /Route.first,
////                 action: /Route.Action.first,
////                 then: First.init
////            )
////            .ifCaseLet(
////                /Route.second,
////                 action: /Route.Action.second,
////                 then: Second.init
////            )
////    }
//
//    var forEachReducers: some ReducerProtocol<Route, Route.Action> {
//        Scope(
//            state: /Route.first,
//            action: /Route.Action.first
//        ) {
//            First()
//        }
//        Scope(
//            state: /Route.second,
//            action: /Route.Action.second
//        ) {
//            Second()
//        }
//    }
//}
//
//// MARK: - View conformances, maybe deserve their own protocol...
//
//extension AppNavigation {
//    static func rootView(store: StoreOf<Route.RootReducer>) -> some View {
//        LandingView(store: store)
//    }
//
//    static func destinationSwitchStore(
//        store: Store<Route, Route.Action>
//    ) -> some View {
//        SwitchStore(store) {
//            CaseLet(
//                state: /Route.first,
//                action: Route.Action.first,
//                then: FirstView.init
//            )
//            CaseLet(
//                state: /Route.second,
//                action: Route.Action.second,
//                then: SecondView.init
//            )
//        }
//    }
//}
