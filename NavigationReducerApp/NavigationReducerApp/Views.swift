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
                    vs.send(.push)
                }

                Button("Present") {
                    vs.send(.present)
                }
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
                    vs.send(.push)
                }

                Button("Pop") {
                    vs.send(.pop)
                }

                Button("Present") {
                    vs.send(.present)
                }

                Spacer()

                Button("Dismiss") {
                    vs.send(.dismiss)
                }
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
                    vs.send(.pop)
                }

                Button("Pop to root") {
                    vs.send(.popToRoot)
                }

                Spacer()

                Button("Dismiss") {
                    vs.send(.dismiss)
                }
            }
        }
    }
}

