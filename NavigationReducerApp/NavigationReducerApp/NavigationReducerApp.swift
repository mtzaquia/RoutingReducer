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
            NavigationStackWithStore<Landing, _, _>(
                store: .init(
                    initialState: .init(),
                    reducer: Landing()
                ),
                rootView: LandingView.init
            ) { store in
                    SwitchStore(store) {
                        CaseLet(
                            state: /AppRoute.first,
                            action: AppRoute.RouteAction.first,
                            then: FirstView.init
                        )
                        CaseLet(
                            state: /AppRoute.second,
                            action: AppRoute.RouteAction.second,
                            then: SecondView.init
                        )
                    }
                }
        }
    }
}


