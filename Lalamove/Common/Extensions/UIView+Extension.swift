//
//  UIView+Extension.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 04/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit

extension UIView {

    func dropShadow(color: UIColor = UIColor.black, opacity: Float = 0.4, offSet: CGSize = CGSize(width: 0, height: 2.0), radius: CGFloat = 3.0) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offSet
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
}
