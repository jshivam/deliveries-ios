//
//  ViewController.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 31/10/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit
import CoreData

class DeliveryViewController: UIViewController {
    let tableView = UITableView()
    let viewModel = DeliveryViewModel.init()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Things to Deliver"
        view.backgroundColor = .white
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.register(DeliveryTableViewCell.self, forCellReuseIdentifier: "cell")

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.tableFooterView = UIView()
        viewModel.frc.delegate = self
        downloadData(forNextPage: false, useCache: true)
    }

    func downloadData(forNextPage: Bool, useCache: Bool) {
        forNextPage ? showFooterLoader() : beginRefreshing()
        viewModel.fetchDeliveries(useCache: useCache, completion: { [weak self] error in
            forNextPage ? self?.hideFooterLoader() : self?.endRefreshing()
            if let error = error {
                self?.showAlert(message: error.localizedDescription)
            }
        })
    }
}
