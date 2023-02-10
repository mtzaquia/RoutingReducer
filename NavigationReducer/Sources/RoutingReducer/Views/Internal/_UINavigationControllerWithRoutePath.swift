//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import UIKit

final class _UINavigationControllerWithRoutePath: UINavigationController {
    func pushViewController(
        _ viewController: UIViewController,
        animated: Bool,
        routeId: AnyHashable
    ) {
        routePathIds.append(routeId)
        super.pushViewController(viewController, animated: animated)
    }

    @discardableResult
    func popToViewControllerAt(
        _ index: Int,
        animated: Bool,
        skipSuper: Bool = false
    ) -> [UIViewController]? {
        let difference = routePathIds.count - index

        defer {
            routePathIds.removeLast(difference)
        }

        if !skipSuper {
            return super.popToViewController(
                viewControllers[index],
                animated: true
            )
        } else {
            return nil
        }
    }
}
