//
//  ViewController.swift
//  Deliveries
//
//  Created by Shivam Jaiswal on 08/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit
import CoreData

class DeliveryListViewController: BaseViewController {

    private struct Constants {
        static let estimatedRowHeight: CGFloat = 44
        static let deliveryCellIndentifier = "cell"
        static let title = LocalizedConstants.deliveryListTitle
    }

    let tableView = UITableView()
    private let viewModel: DeliveryListViewModelProtocol

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
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(DeliveryTableViewCell.self, forCellReuseIdentifier: Constants.deliveryCellIndentifier)
        tableView.tableFooterView = UIView()

        addConstraints()

        viewModel.fetchedResultsControllerDelegate = self

        downloadData(forNextPage: false, useCache: true)
    }

    private func addConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func downloadData(forNextPage: Bool, useCache: Bool) {
        forNextPage ? showFooterLoader() : beginRefreshing()
        viewModel.fetchDeliveries(useCache: useCache, completion: { [weak self] status in
            forNextPage ? self?.hideFooterLoader() : self?.endRefreshing()
            switch status {
            case .faliure(let error):
                self?.view.showToast(error.localizedDescription)
            default:
                break
            }
        })
    }
}

extension DeliveryListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.item(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.deliveryCellIndentifier, for: indexPath) as? DeliveryTableViewCell
        cell?.update(text: item.title, imageUrl: item.imageURL)
        return cell!
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(section: section)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.lastVisibileIndexPath = indexPath
        viewModel.fetchNextDataHandler = { [weak self] _ in
            self?.downloadData(forNextPage: true, useCache: true)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let delivery = viewModel.delivery(at: indexPath)
        let detailViewModel = DeliveryDetailViewModel.init(delivery: delivery)
        let detailViewController = DeliveryDetailViewController.init(viewModel: detailViewModel)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension DeliveryListViewController: TableViewRefreshable {
    func refreshData() {
        downloadData(forNextPage: false, useCache: false)
    }
}

extension DeliveryListViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }

        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }

        case .move:

            if let deleteIndexPath = indexPath {
                tableView.deleteRows(at: [deleteIndexPath], with: .fade)
            }
            if let insertIndexPath = newIndexPath {
                tableView.insertRows(at: [insertIndexPath], with: .fade)
            }

        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        @unknown default:
            break
        }
    }
}

extension DeliveryListViewController: TableViewFooterLoadable {}
