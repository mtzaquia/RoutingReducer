//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture

public protocol Routing: Equatable, Hashable, Identifiable {
    associatedtype Action
}

