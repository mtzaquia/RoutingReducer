//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import NavigationReducer

struct Modal: ReducerProtocol {
    struct State: RoutedState {
        let id = UUID()
        @BindingState var modalText: String = ""
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)

        case presentAnother
        case dismiss
    }

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        EmptyReducer()
    }
}

struct ModalView: View {
    let store: StoreOf<Modal>
    var body: some View {
        WithViewStore(store) { vs in
            VStack {
                Text("Modal")
//                Button("Present") {
//                    vs.send(.presentOtherModal)
//                }

                TextField("Input", text: vs.binding(\.$modalText))
                    .padding()

                Button("Dismiss") {
                    vs.send(.dismiss)
                }
                .padding(.top, 16)
            }
        }
    }
}

