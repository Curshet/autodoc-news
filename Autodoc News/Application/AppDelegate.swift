//
//  AppDelegate.swift
//  Autodoc News
//
//  Created by User on 15.02.2025.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        let viewController = ViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        return true
    }

}
