//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import NavigationReducer

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
                    vs.send(.presentLanding)
                }

                TextField("Input", text: vs.binding(\.$landingText))
                    .padding()
            }
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

                Button("Present") {
                    vs.send(.present)
                }

                TextField("Input", text: vs.binding(\.$firstText))
                    .padding()

                Button("Dismiss") {
                    vs.send(.dismiss)
                }
                .padding(.top, 16)
            }
        }
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

                Button("Dismiss") {
                    vs.send(.dismiss)
                }
                .padding(.top, 16)
            }
        }
    }
}

// MARK: -

struct ModalLandingView: View {
    let store: StoreOf<ModalLanding>
    var body: some View {
        NavigationStackWithStore<ModalLanding, _, _>(
            store: .init(
                initialState: .init(),
                reducer: ModalLanding()
            )
        ) { store in
            WithViewStore(store) { vs in
                VStack {
                    Text("Modal landing")
                    Button("Present") {
                        vs.send(.presentOtherModal)
                    }

                    TextField("Input", text: vs.binding(\.$modalText))
                        .padding()

                    Button("Dismiss") {
                        vs.send(.dismiss)
                    }
                    .padding(.top, 16)
                }
            }
        } routeViews: { store in
            SwitchStore(store) {
                CaseLet(
                    state: /ModalRoute.first,
                    action: ModalRoute.RouteAction.first,
                    then: FirstView.init
                )
            }
        }
    }
}

