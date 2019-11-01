//
//  ViewController.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 31/10/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit
import CoreData

class DeliveryViewController: UIViewController, AlertPresentable, TableViewFooterLoadable
{
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
        tableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        tableView.tableFooterView = UIView()
        viewModel.frc.delegate = self
        downloadData(forNextPage: false, useCache: true)
    }
    
    func downloadData(forNextPage: Bool, useCache: Bool)
    {
        forNextPage ? showFooterLoader() : beginRefreshing()
        viewModel.fetchDeliveries(useCache: useCache, completion: { [weak self] error in
            forNextPage ? self?.hideFooterLoader() : self?.endRefreshing()
            if let error = error {
                self?.showAlert(message: error.localizedDescription)
            }
        })
    }
}

extension DeliveryViewController: TableViewRefreshable
{
    func refreshData()
    {
        viewModel.deleteAllDeliveries()
        downloadData(forNextPage: false, useCache: false)
    }
}

extension DeliveryViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let delivery = viewModel.frc.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DeliveryTableViewCell
        cell.update(text: delivery.desc, imageUrl: delivery.imageUrl)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRow()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if viewModel.isLastCell(indexPath: indexPath) {
            let delivery = viewModel.frc.object(at: indexPath)
            viewModel.currentOffSet = Int(delivery.offSet)
            downloadData(forNextPage: true, useCache: false)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let delivery = viewModel.frc.object(at: indexPath)
        let detailViewModel = DeliveryDetailViewModel.init(delivery: delivery)
        let detailViewController = DeliveryDetailViewController.init(viewModel: detailViewModel)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension DeliveryViewController : NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
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
            if let indexPath = indexPath{
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
            break;
        @unknown default:
            break;
        }
    }
}
