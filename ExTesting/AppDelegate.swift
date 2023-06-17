//
//  AppDelegate.swift
//  ExTesting
//
//  Created by 김종권 on 2023/06/17.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController(viewModel: ViewModel(dependency: .init(count: nil)))
        window?.makeKeyAndVisible()
        return true
    }
}

