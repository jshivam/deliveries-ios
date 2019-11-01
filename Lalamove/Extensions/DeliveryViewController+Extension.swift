//
//  DeliveryViewController+Extension.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 01/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import Foundation
import CoreData
import UIKit

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

extension DeliveryViewController: TableViewRefreshable
{
    func refreshData()
    {
        viewModel.deleteAllDeliveries()
        downloadData(forNextPage: false, useCache: false)
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

extension DeliveryViewController: AlertPresentable {}
extension DeliveryViewController: TableViewFooterLoadable {}
