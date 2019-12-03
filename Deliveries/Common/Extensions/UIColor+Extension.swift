//
//  UIColor+Extension.swift
//  Deliveries
//
//  Created by Shivam Jaiswal on 03/12/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit

extension UIColor {
    private struct AssetsColor {
        static let titleColor = "titleColor"
        static let loaderColor = "loaderColor"
        static let backgroundColor = "backgroundColor"
    }

    static var titleColor: UIColor { return UIColor.init(named: AssetsColor.titleColor)! }
    static var loaderColor: UIColor { return UIColor.init(named: AssetsColor.loaderColor)! }
    static var backgroundColor: UIColor { return UIColor.init(named: AssetsColor.backgroundColor)! }
}
