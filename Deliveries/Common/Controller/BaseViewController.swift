//
//  BaseViewController.swift
//  Deliveries
//
//  Created by Shivam Jaiswal on 03/12/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        view.backgroundColor = .backgroundColor
        navigationBackButttonSetup()
    }

    func navigationBackButttonSetup() {
        let backButton = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
    }
}
