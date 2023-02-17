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
