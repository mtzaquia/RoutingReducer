//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import struct SwiftUI.NavigationPath
import ComposableArchitecture

public struct _NavigationReducer<Destination: NavigationDestination>: ReducerProtocol {
    public struct State: Equatable {
        @BindingState var navigationPath: NavigationPath
        public var destinationPath: IdentifiedArrayOf<Destination>
        public var currentModal: Destination?

        public init(
            destinationPath: IdentifiedArrayOf<Destination> = .init(),
            currentModal: Destination? = nil
        ) {
            navigationPath = .init(destinationPath.elements)
            self.destinationPath = destinationPath
            self.currentModal = currentModal
        }
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case present(Destination)
        case dismiss
        case push(Destination)
        case pop(toRoot: Bool = false)
    }

    public var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                case .present(let destination):
                    state.currentModal = destination
                    return .none
                case .dismiss:
                    state.currentModal = nil
                    return .none
                case .push(let destination):
                    state.navigationPath.append(destination.id)
                    state.destinationPath.append(destination)
                    return .none
                case .pop(let toRoot):
                    state.navigationPath.removeLast(
                        toRoot ? state.navigationPath.count : min(state.navigationPath.count, 1)
                    )
                    state.destinationPath.removeLast(
                        toRoot ? state.destinationPath.count : min(state.destinationPath.count, 1)
                    )
                    return .none
                case .binding:
                    return .none
            }
        }
    }
}
