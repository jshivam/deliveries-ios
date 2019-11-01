//
//  TableViewRefreshable.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 01/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit

@objc protocol TableViewProtocol {
    var tableView: UITableView {get}
}

@objc protocol TableViewRefreshable: TableViewProtocol {
    func refreshData()
}

extension TableViewRefreshable {
    func beginRefreshing()
    {
        if let refreshControl = self.tableView.refreshControl, refreshControl.isRefreshing { return }
        let refreshControl = UIRefreshControl.init()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        self.tableView.refreshControl?.beginRefreshing()
    }
    
    func endRefreshing(){
        self.tableView.refreshControl?.endRefreshing()
    }
}
