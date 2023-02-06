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

    // TODO: how to move this to state, so that the same "destination" could be pushed twice with diff state
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
            case .root(.pushFirst): return .push(.first(First.State()))
//            case .root(.present): return .present(.first(.init()))
            case .destination(_, .first(.pushSecond)): return .push(.second(Second.State()))
            case .destination(_, .first(.popToLanding)): return .pop()
//            case .destination(_, .first(.present)): return .present(.second(.init()))
//            case .destination(_, .first(.dismiss)): return .dismiss
            case .destination(_, .second(.popToFirst)): return .pop()
            case .destination(_, .second(.popToRoot)): return .pop(toRoot: true)
//            case .destination(_, .second(.dismiss)): return .dismiss
            default: break
        }

        return nil
    }

    var rootReducer = Landing()

//    func ifCaseLetReducer(
//        _ baseReducer: EmptyReducer<Destination?, Destination.Action>
//    ) -> some ReducerProtocol<Destination?, Destination.Action> {
//        baseReducer
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
}

// MARK: - View conformances, maybe deserve their own protocol...

extension AppNavigation {
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
