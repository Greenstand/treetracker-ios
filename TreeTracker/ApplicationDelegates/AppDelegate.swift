//
//  AppDelegate.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 30/04/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootCoordinator: Coordinator?

    lazy var coreDataManager: CoreDataManaging = {
        return CoreDataManager()
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        AWSS3Client().registerS3CLient()

        // For iOS13+ we setup the root coordinator in the scene delegate
        guard #available(iOS 13.0, *) else {
            let navigationController = BaseNavigationViewController()

            let configuration = CoordinatorConfiguration(
                navigationController: navigationController
            )

            rootCoordinator = RootCoordinator(
                configuration: configuration,
                coreDataManager: coreDataManager
            )
            rootCoordinator?.start()

            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
            return true
        }

        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        coreDataManager.saveContext()
    }

    // MARK: - UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}
