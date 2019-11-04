//
//  DeliveryViewModelProtocol.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 03/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import Foundation
import UIKit
protocol DeliveryViewModelProtocol {
    var currentOffSet: Int { get }
    var deliveryServices: DeliveryServiceProtocol { get }
    var isFetchingDeliveries: Bool { get }

    func numberOfSections() -> Int
    func numberOfRows(section: Int) -> Int
    func heightForRow() -> CGFloat
    func deleteAllDeliveries()
    func resetState()
    func cacheExists(offSet: Int) -> Bool
    func shallFetchNextData(indexPath: IndexPath) -> Bool
    func fetchDeliveries(useCache: Bool, completion: @escaping (Error?) -> Void)
    func saveDeliveries()
}
