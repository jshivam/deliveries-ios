//
//  TableViewFooterLoader.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 01/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit

protocol TableViewFooterLoadable: TableViewProtocol {
    func showFooterLoader()
}

extension TableViewFooterLoadable {
    func showFooterLoader() {
        let loader = UIActivityIndicatorView.init(style: .gray)
        loader.startAnimating()
        self.tableView.tableFooterView = loader
    }

    func hideFooterLoader() {
        self.tableView.tableFooterView = UIView()
    }
}
