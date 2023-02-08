//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import NavigationReducer

struct First: ReducerProtocol {
    struct State: RoutedState {
        let id = UUID()
        @BindingState var firstText: String = ""
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case pushSecond
        case popToLanding
        case present
        case dismiss
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            return .none
        }
    }
}

struct FirstView: View {
    let store: StoreOf<First>
    var body: some View {
        WithViewStore(store) { vs in
            VStack {
                Text("First")
                Button("Push") {
                    vs.send(.pushSecond)
                }

                Button("Pop") {
                    vs.send(.popToLanding)
                }

                TextField("Input", text: vs.binding(\.$firstText))
                    .padding()

//                Button("Dismiss") {
//                    vs.send(.dismiss)
//                }
//                .padding(.top, 16)
            }
        }
    }
}
