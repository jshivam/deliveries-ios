//
//  Toast.swift
//  Deliveries
//
//  Created by Shivam Jaiswal on 08/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import Toast_Swift

class Toast {

    private init() {}

    struct Constants {
        static let animationDuration: TimeInterval = 2.0
    }

    static func configure() {
        var style = ToastStyle()
        style.messageColor = .white
        ToastManager.shared.style = style
        ToastManager.shared.isTapToDismissEnabled = true
        ToastManager.shared.isQueueEnabled = true
    }
}
