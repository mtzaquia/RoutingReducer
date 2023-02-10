# RoutingReducer

RoutingReducer is a library aiming at an improved developer experience for stateful navigation on TCA. It is loosely inspired by the coordinator pattern.

## Instalation

RoutingReducer is available via Swift Package Manager.

```swift
dependencies: [
  .package(url: "https://github.com/mtzaquia/RoutingReducer.git", .upToNextMajor(from: "0.0.9")),
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
- The body must provide an instance of `Router`

```swift
struct MyRouter: RoutingReducerProtocol {
    enum Route: Routing {
        // the available routes, their actions and IDs. 
    }

    struct State: RoutingState {
        let id = UUID() // declaring an arbitrary ID is fine.
        var navigation: Route.NavigationState = .init()
        var root: MyRoot.State
    }
    
    enum Action: RoutingAction {
        case navigation(Route.NavigationAction)
        case route(UUID, Route.RouteAction)
        case modalRoute(Route.RouteAction)
        case root(MyRoot.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Router { action in
            // a closure resolving reducer actions to a navigation action.
            return nil
        } rootReducer: {
            MyRoot()
        } routeReducer: {
            Scope(
                state: /Route.first,
                action: /Route.RouteAction.first,
                First.init
            )
            // other scoped reducers for all routes declared... 
        }
    }
}
```

#### Routing

The `Routing` protocol defines all available routes for a given flow, and is a required conformance to the `Route` type on `RoutingReducerProtocol` conformances.

It is important to mention that routes require an ID. The way the ID is defined will determine whether the same view can be pushed/presented more than once on the same flow. That's why states belonging to a flow must conform to `RoutedState`.

For example, the conformance below allows for the same screen to be pushed multiple times, as it uses the state's ID to identify itself:

```swift
enum Route: Routing {
    case first(First.State)
    case second(Second.State)

    enum RouteAction {
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

    enum RouteAction {
        case first(First.Action)
    }

    var id: UUID {
        switch self {
            case .first: return "first"
        }
    }
}
```

### NavigationStackWithStore (iOS 16+) / NavigationControllerWithStore (iOS 15)

_..._

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
