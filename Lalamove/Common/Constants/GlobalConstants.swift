//
//  Constants.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 31/10/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import Foundation
import UIKit

struct GlobalConstants {
    private init() {}

    static var deliveryLimitPerRequest: Int { return 20 }
    static var defautlCornerRadius: CGFloat { return 8 }
    static var defaultSidePadding: CGFloat {return 15 }
}

struct LocalizedConstants {
    private init() {}

    static let apiError = "apiError".localized()
    static let noData = "noData".localized()
    static let noInternet = "noInternet".localized()

    static let okButtonTitle = "okButtonTitle".localized()

    static let deliveryListTitle = "deliveryListTitle".localized()
    static let deliveryDetailTitle = "deliveryDetailTitle".localized()
}
