//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture

struct Landing: ReducerProtocol {
    struct State: Equatable {}
    enum Action {
        case push
        case present
    }
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            print("Landing", action)
            return .none
        }
    }
}

struct First: ReducerProtocol {
    struct State: Hashable, Equatable {}
    enum Action: Hashable {
        case push
        case pop
        case present
        case dismiss
    }
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            print("First", action)
            return .none
        }
    }
}

struct Second: ReducerProtocol {
    struct State: Hashable, Equatable {}
    enum Action: Hashable {
        case pop
        case popToRoot
        case dismiss
    }
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            print("Second", action)
            return .none
        }
    }
}
