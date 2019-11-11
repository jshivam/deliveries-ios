//
//  AppDelegate.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 31/10/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init(frame: UIScreen.main.bounds)

        FirebaseManager.configure()

        let coreData = CoreDataManager.sharedInstance
        let deliveryService = DeliveryService()
        let viewMolel = DeliveryListViewModel.init(deliveryServices: deliveryService, coreData: coreData)
        let deliveryViewController = DeliveryListViewController.init(viewModel: viewMolel)
        let navigationController = UINavigationController.init(rootViewController: deliveryViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}
