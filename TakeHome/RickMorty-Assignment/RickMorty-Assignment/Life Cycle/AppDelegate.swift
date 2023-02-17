//
//  AppDelegate.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 17/02/23.
//

import UIKit

@main final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration",
                                    sessionRole: connectingSceneSession.role)
    }
    
    private func setupDependencies() {
        DependencyContainer.setDependency(initialValue: Webservice(),
                                          key: WebserviceDependencyKey.self)
    }

}

