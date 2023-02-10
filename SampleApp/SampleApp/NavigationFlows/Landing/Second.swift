//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import RoutingReducer

struct Second: ReducerProtocol {
    struct State: RoutedState {
        let id = UUID()
        @BindingState var secondText: String = ""
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case popToFirst
        case popToRoot
//        case dismiss
    }

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        EmptyReducer()
    }
}

struct SecondView: View {
    let store: StoreOf<Second>
    var body: some View {
        WithViewStore(store) { vs in
            VStack {
                Text("Second")
                Button("Pop") {
                    vs.send(.popToFirst)
                }

                Button("Pop to root") {
                    vs.send(.popToRoot)
                }

                TextField("Input", text: vs.binding(\.$secondText))
                    .padding()

//                Button("Dismiss") {
//                    vs.send(.dismiss)
//                }
//                .padding(.top, 16)
            }
        }
    }
}

