//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import NavigationReducer

struct Landing: ReducerProtocol {
    struct State: RoutedState {
        let id = UUID()
        @BindingState var landingText: String = ""
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)

        case pushFirst
        case presentModal
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            return .none
        }
    }
}

struct LandingView: View {
    let store: StoreOf<Landing>
    var body: some View {
        WithViewStore(store) { vs in
            VStack {
                Text("Landing")
                Button("Push") {
                    vs.send(.pushFirst)
                }

                Button("Present") {
                    vs.send(.presentModal)
                }

                TextField("Input", text: vs.binding(\.$landingText))
                    .padding()
            }
        }
    }
}

