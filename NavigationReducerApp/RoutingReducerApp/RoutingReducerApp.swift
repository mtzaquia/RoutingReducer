//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import SwiftUI

@main
struct RoutingReducerApp: App {
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


