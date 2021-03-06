//
//  AppDelegate.swift
//  Deliveries
//
//  Created by Shivam Jaiswal on 08/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init(frame: UIScreen.main.bounds)

        FirebaseManager.configure()
        Toast.configure()

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
