//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import Foundation

public protocol NavigationDestination: Hashable, Identifiable {
    typealias NavigationState = _NavigationReducer<Self>.State
    typealias NavigationAction = _NavigationReducer<Self>.Action

    associatedtype Action
}
