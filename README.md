# RoutingReducer

RoutingReducer is a library aiming at an improved developer experience for stateful navigation on TCA. It is loosely inspired by the coordinator pattern.

## Instalation

RoutingReducer is available via Swift Package Manager.

```swift
dependencies: [
  .package(url: "https://github.com/mtzaquia/RoutingReducer.git", .upToNextMajor(from: "0.0.10")),
],
```

## Usage

RoutingReducer builds a developer-friendly navigation pattern on top of [The Composable Architecture (TCA)](https://github.com/pointfreeco/swift-composable-architecture). It tries to use familiar concepts for those already working with TCA, and is designed to be attached to an existing implementation of reducers, assuming they are already using the latest `ReducerProtocol` approach. 

### RoutingReducerProtocol

The `RoutingReducerProtocol` is the base for a given flow. It is the one that will be used to build the root view and handle all the possible navigation routes available within the routes it defines.

It is essentially a `ReducerProtocol`, but with additional requirements:
- The `State` must conform to `RoutingState`
- The `Action` mut conform to `RoutingAction`
- A type called `Route` must be declared, and it must conform to `Routing`
- Instead of `body`, you need to provide `rootBody`, `routeBody` and a function to bridge reducer actions to concrete navigation actions.

```swift
struct MyRouter: RoutingReducerProtocol {
    enum Route: Routing {
        // the available routes for this reducer, their actions and IDs. 
    }

    struct State: RoutingState {
        let id = UUID() // declaring an arbitrary ID is fine.
        var navigation: Route.NavigationState = .init()
        var root: MyRoot.State
    }
    
    enum Action: RoutingAction {
        case navigation(Route.NavigationAction)
        case route(UUID, Route.Action)
        case modalRoute(Route.Action)
        case root(MyRoot.Action)
    }

    var rootBody: some RootReducer<Self> {
        MyRoot()
    }
    
    var routeBody: some RouteReducer<Self> {
        Scope(
            state: /Route.first,
            action: /Route.Action.first,
            First.init
        )
        // other scoped reducers for all routes declared on this reducer... 
    }
    
    func navigation(for action: Action) -> Route.NavigationAction? {
        // a closure resolving this reducer's actions to a navigation action.
    }
}
```

#### Routing

The `Routing` protocol defines all available routes for a given flow, and is a required conformance to the `Route` type on `RoutingReducerProtocol` conformances.

It is important to mention that routes require an ID. The way the ID is defined will determine whether the same view can be pushed/presented more than once on the same flow. That's why states belonging to a flow must conform to `RoutedState`.

For example, the conformance below allows for the same screen to be pushed multiple times, as it uses the state's ID to identify itself (assuming namely IDs are different):

```swift
enum Route: Routing {
    case first(First.State)
    case second(Second.State)

    enum Action {
        case first(First.Action)
        case second(Second.Action)
    }

    var id: UUID {
        switch self {
            case .first(let state): return state.id
            case .second(let state): return state.id
        }
    }
}
``` 

Whereas the example below will never allow for `first` to be presented more than once:

```swift
enum Route: Routing {
    case first(First.State)

    enum Action {
        case first(First.Action)
    }

    var id: UUID {
        switch self {
            case .first: return "first"
        }
    }
}
```

### WithRoutingStore

_..._

### RoutedNavigationStack

The view used for installing and displaying a navigation flow is `RoutedNavigationStack`.

This views receive the appropriate navigation state extracted from your store using `WithRoutingStore` and, similarly to the Router, the root view for the navigation.

Most commonly, usages of this view will follow the pattern below:

```swift
struct MyRouterView: View {
    let store: StoreOf<MyRouter>
    var body: some View {
        WithRoutingStore(store) { rootStore, navigation, _ in
            RoutedNavigationStack(navigation: navigation) {
                // The root view receives the scoped store 
                //  of `MyRouter`'s root state and root action 
                MyRootView(store: rootStore)
            }
        } routes: { store in
            // All your route views with SwitchStore/CaseLet...
        }
    }
}
```

## Known limitations and issues

- Effect cancellation needs to be handled manually;
- Dismissing a screen while editing a value with @BindingState will warn of unhandled actions.

## License

Copyright (c) 2023 @mtzaquia

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
