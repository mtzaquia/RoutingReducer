//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture
import NavigationReducer
import SwiftUI

enum AppDestination: NavigationDestination {
    typealias RootReducer = Landing

    enum Action {
        case first(First.Action)
        case second(Second.Action)
    }

    case first(First.State)
    case second(Second.State)

    var id: String {
        switch self {
            case .first: return "first"
            case .second: return "second"
        }
    }
}

struct AppNavigation: NavigationReducerProtocol {
    typealias Destination = AppDestination

    func handleNavigation(_ action: NavigationAction<AppDestination>) -> AppDestination.NavigationAction? {
        switch action {
            case .root(.push): return .push(.first(.init()))
//            case .root(.present): return .present(.first(.init()))
            case .destination(_, .first(.push)): return .push(.second(.init()))
            case .destination(_, .first(.pop)): return .pop()
//            case .destination(_, .first(.present)): return .present(.second(.init()))
            case .destination(_, .second(.pop)): return .pop()
            case .destination(_, .second(.popToRoot)): return .pop(toRoot: true)
            default: break
        }

        return nil
    }

    var rootReducer = Landing()

//    var ifLetReducer: some ReducerProtocol<Destination, Destination.Action> {
//        EmptyReducer()
//            .ifCaseLet(
//                /Destination.first,
//                 action: /Destination.Action.first,
//                 then: First.init
//            )
//            .ifCaseLet(
//                /Destination.second,
//                 action: /Destination.Action.second,
//                 then: Second.init
//            )
//    }

    var forEachReducers: some ReducerProtocol<Destination, Destination.Action> {
        Scope(
            state: /Destination.first,
            action: /Destination.Action.first
        ) {
            First()
        }
        Scope(
            state: /Destination.second,
            action: /Destination.Action.second
        ) {
            Second()
        }
    }

    static func rootView(store: StoreOf<Destination.RootReducer>) -> some View {
        LandingView(store: store)
    }

    static func destinationSwitchStore(
        store: Store<Destination, Destination.Action>
    ) -> some View {
        SwitchStore(store) {
            CaseLet(
                state: /Destination.first,
                action: Destination.Action.first,
                then: FirstView.init
            )
            CaseLet(
                state: /Destination.second,
                action: Destination.Action.second,
                then: SecondView.init
            )
        }
    }
}
