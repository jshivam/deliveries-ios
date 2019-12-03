//
//  ForceToucable.swift
//  Deliveries
//
//  Created by Shivam Jaiswal on 03/12/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit

protocol ForceTouchable: UIViewControllerPreviewingDelegate {
    func registerForceTouchForPreviewing(sourceView: UIView)
}

extension ForceTouchable where Self: UIViewController {
    func registerForceTouchForPreviewing(sourceView: UIView) {
        if UIApplication.canSupportForceTouch {
            registerForPreviewing(with: self, sourceView: sourceView)
        }
    }
}
