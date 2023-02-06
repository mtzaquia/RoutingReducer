//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct LandingView: View {
    let store: StoreOf<Landing>
    var body: some View {
        WithViewStore(store) { vs in
            VStack {
                Text("Landing")
                Button("Push") {
                    vs.send(.pushFirst)
                }

//                Button("Present") {
//                    vs.send(.present)
//                }

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

//                Button("Present") {
//                    vs.send(.present)
//                }

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

