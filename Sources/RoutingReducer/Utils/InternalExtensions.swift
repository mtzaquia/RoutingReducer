//
// Created by Mauricio Tremea Zaquia
// Copyright ® 2023 Mauricio Tremea Zaquia. All rights reserved.
//

import UIKit

private var routePathIdsKey: Void?
extension UINavigationController {
    var routePathIds: [AnyHashable] {
        get {
            return objc_getAssociatedObject(self, &routePathIdsKey) as? [AnyHashable] ?? []
        }
        set {
            objc_setAssociatedObject(self, &routePathIdsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
