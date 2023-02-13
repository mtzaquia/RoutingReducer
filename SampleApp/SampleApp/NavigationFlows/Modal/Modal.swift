//
//  Copyright (c) 2023 @mtzaquia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import SwiftUI
import ComposableArchitecture
import RoutingReducer

struct Modal: ReducerProtocol {
    struct State: RoutedState {
        let id = UUID()
        @BindingState var modalText: String = ""
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)

        case presentAnother
        case replace
        case dismiss
    }

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
    }
}

struct ModalView: View {
    let store: StoreOf<Modal>
    var body: some View {
        WithViewStore(store) { vs in
            VStack {
                Button("Present") {
                    vs.send(.presentAnother)
                }

                Button("Replace") {
                    vs.send(.replace)
                }
                .padding(.top, 16)

                TextField("Input", text: vs.binding(\.$modalText))
                    .padding()

                Button("Dismiss") {
                    vs.send(.dismiss)
                }
                .padding(.top, 16)
            }
            .navigationBarTitle("Modal")
        }
    }
}

