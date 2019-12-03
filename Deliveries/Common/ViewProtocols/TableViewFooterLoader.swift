//
//  TableViewFooterLoader.swift
//  Deliveries
//
//  Created by Shivam Jaiswal on 08/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit

protocol TableViewFooterLoadable: TableViewProtocol {
    func showFooterLoader()
    func hideFooterLoader()
}

extension TableViewFooterLoadable {
    func showFooterLoader() {
        let loaderView = LoaderView.init(frame: .zero)
        let height = loaderView.preferredHeight
        loaderView.frame = CGRect.init(x: 0, y: 0, width: 0, height: height)
        loaderView.loader.startAnimating()
        self.tableView.tableFooterView = loaderView
        loaderView.setNeedsLayout()
    }

    func hideFooterLoader() {
        self.tableView.tableFooterView = UIView()
    }
}
