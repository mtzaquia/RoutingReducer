//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

/// A wrapper for a modal presentation state.
///
/// Instances of this wrapper are acquired via declarations of ``WithRoutingStore``
/// and its properties ``item`` and ``content`` shoulde be provided to a presentation
/// modifier, such as `.sheet(item:content:)` or `.fullCover(item:content)`.
public final class Modal<Route: Routing, RouteView: View> {
    /// The binding that indicates whether this presentation is active.
    public let item: Binding<Route?>
    /// A closure for rendering the appropriate view, whenever this modal presentation is ready.
    public let content: (Route) -> IfLetStore<Route, Route.Action, RouteView?>

    init(
        item: Binding<Route?>,
        content: @escaping (Route) -> IfLetStore<Route, Route.Action, RouteView?>
    ) {
        self.item = item
        self.content = content
    }
}
