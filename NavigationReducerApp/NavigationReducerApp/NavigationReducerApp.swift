//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import NavigationReducer

@main
struct NavigationReducerApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStackWithStore<LandingRouter, _, _>(
                store: .init(
                    initialState: .init(root: .init()),
                    reducer: LandingRouter()
                ),
                rootView: LandingView.init
            ) { store in
                SwitchStore(store) {
                    CaseLet(
                        state: /LandingRoute.first,
                        action: LandingRoute.RouteAction.first,
                        then: FirstView.init
                    )
                    CaseLet(
                        state: /LandingRoute.second,
                        action: LandingRoute.RouteAction.second,
                        then: SecondView.init
                    )
                    CaseLet(
                        state: /LandingRoute.modalRouter,
                        action: LandingRoute.RouteAction.modalRouter,
                        then: ModalRouterView.init
                    )
                }
            }
        }
    }
}


