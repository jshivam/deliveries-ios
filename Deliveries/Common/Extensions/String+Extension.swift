//
//  String+Extension.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 04/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import Foundation

extension String {
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
