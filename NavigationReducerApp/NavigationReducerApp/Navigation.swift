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
    case modalLanding(ModalLanding.State)

    enum RouteAction {
        case first(First.Action)
        case second(Second.Action)
        case modalLanding(ModalLanding.Action)
    }

    var id: UUID {
        switch self {
            case .first(let state): return state.id
            case .second(let state): return state.id
            case .modalLanding(let state): return state.id
        }
    }
}

enum ModalRoute: Routing {
    case first(First.State)

    enum RouteAction {
        case first(First.Action)
    }

    var id: UUID {
        switch self {
            case .first(let state): return state.id
        }
    }
}
