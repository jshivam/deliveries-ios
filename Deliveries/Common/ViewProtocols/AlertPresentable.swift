//
//  Alertable.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 01/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit

protocol AlertPresentable {
    func showAlert(title: String?, message: String?)
}

extension AlertPresentable where Self: UIViewController {
    func showAlert(title: String? = nil, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: LocalizedConstants.okButtonTitle, style: .default) {(_) in }
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
}