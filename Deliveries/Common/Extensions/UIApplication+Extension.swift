//
//  UIApplication+Extension.swift
//  Deliveries
//
//  Created by Shivam Jaiswal on 03/12/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit

extension UIApplication {
    static var canSupportForceTouch: Bool {
        return UIApplication.shared.keyWindow?.traitCollection.forceTouchCapability == UIForceTouchCapability.available
    }
}
