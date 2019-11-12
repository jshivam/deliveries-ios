//
//  UIView+Extension.swift
//  Deliveries
//
//  Created by Shivam Jaiswal on 08/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit
import Toast_Swift

extension UIView {

    func dropShadow(color: UIColor = UIColor.black, opacity: Float = 0.4, offSet: CGSize = CGSize(width: 0, height: 2.0), radius: CGFloat = 3.0) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offSet
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }

    func showToast(_ message: String?) {
        self.makeToast(message, duration: Toast.Constants.animationDuration, position: .bottom, style: ToastManager.shared.style)
    }

    func hide() {
        self.hideAllToasts()
    }
}
