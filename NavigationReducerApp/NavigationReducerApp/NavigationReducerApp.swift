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
            LandingRouterView(
                store: .init(
                    initialState: .init(root: .init()),
                    reducer: LandingRouter()
                )
            )
        }
    }
}


