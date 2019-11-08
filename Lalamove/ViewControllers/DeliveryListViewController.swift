//
//  ViewController.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 31/10/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit
import CoreData

class DeliveryListViewController: UIViewController {

    struct Constants {
        static let deliveryCellIndentifier = "cell"
        static let title = "deliveryListTitle".localized()
    }

    let tableView = UITableView()
    let viewModel: DeliveryListViewModelProtocol

    init(viewModel: DeliveryListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = Constants.title
        view.backgroundColor = .white
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(DeliveryTableViewCell.self, forCellReuseIdentifier: Constants.deliveryCellIndentifier)
        tableView.tableFooterView = UIView()

        addConstraints()

        viewModel.frc.delegate = self

        downloadData(forNextPage: false, useCache: true)
    }

    func addConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func downloadData(forNextPage: Bool, useCache: Bool) {
        forNextPage ? showFooterLoader() : beginRefreshing()
        viewModel.fetchDeliveries(useCache: useCache, completion: { [weak self] status in
            forNextPage ? self?.hideFooterLoader() : self?.endRefreshing()
            switch status {
            case .faliure(let error):
                self?.showAlert(message: error.localizedDescription)
            default:
                break
            }
        })
    }
}
