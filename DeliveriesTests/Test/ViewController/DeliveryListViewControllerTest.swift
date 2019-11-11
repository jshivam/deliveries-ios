//
//  DeliveryListViewControllerTest.swift
//  LalamoveTests
//
//  Created by Shivam Jaiswal on 10/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import XCTest
@testable import Deliveries

class DeliveryListViewControllerTest: XCTestCase {

    var window: UIWindow!
    var navigation: UINavigationController!
    var deliveryListViewController: DeliveryListViewController!
    var viewModel: DeliveryListViewModelMock!

    var coreData: CoreDataManager! = CoreDataManager.init(config: CoreDataMockConfig())
    var apiPerformer: APIPerformer!
    var session: SessionManagerMock!
    var deliveryService: DeliveryService!
    var configMock: APISessionConfigurationMock!

    override func setUp() {
        session = SessionManagerMock()
        apiPerformer = APIPerformer(manager: session)
        configMock = APISessionConfigurationMock()
        deliveryService = DeliveryService(apiPerformer: apiPerformer, sessionConfiguration: configMock)
        viewModel = DeliveryListViewModelMock.init(deliveryServices: deliveryService, coreData: coreData)
        deliveryListViewController = DeliveryListViewController.init(viewModel: viewModel)
        navigation = UINavigationController.init(rootViewController: deliveryListViewController)

        UIApplication.shared.windows.first?.rootViewController = navigation
    }

    override func tearDown() {
        deliveryListViewController = nil
        viewModel = nil
        coreData = nil
        apiPerformer = nil
        session = nil
        deliveryService = nil
        configMock = nil
        navigation = nil
        window = nil
    }

    func testNumberOfSections() {
        XCTAssertEqual(deliveryListViewController.numberOfSections(in: deliveryListViewController.tableView), viewModel.numberOfSections())
    }

    func testNumberOfRows() {
        XCTAssertEqual(deliveryListViewController.tableView(deliveryListViewController.tableView, numberOfRowsInSection: 0), viewModel.numberOfRows(section: 0))
    }

    func testRefreshData() {
        deliveryListViewController.refreshData()
        XCTAssertEqual(viewModel.useCache, false)
    }
}
