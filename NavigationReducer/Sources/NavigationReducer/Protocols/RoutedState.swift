//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import Foundation

/// Describes a state that can be routed to, either as a root, pushed or modal screen.
///
/// - Important: Every state that's part of a ``Routing`` type **must** conform to this protocol.
///
/// - Usage:
/// ```
/// struct First: ReducerProtocol {
///     struct State: RoutedState {
///         let id = UUID()
///         // ...
///     }
///
///     // ...
/// }
/// ```
public protocol RoutedState: Equatable, Hashable, Identifiable {}
