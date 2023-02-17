//
//  ViewController.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 17/02/23.
//

import UIKit

final class MainTabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        viewControllers = [
            createNavController(for: EpisodesVC(),
                                title: "Episodes",
                                activeIcon: ImageAsset.TAB_EPISODES_ACTIVE,
                                inactiveIcon: ImageAsset.TAB_EPISODES_INACTIVE)
        ]
        
        tabBar.isTranslucent = true
    }
    
    private func createNavController(for vc: UIViewController,
                                     title: String,
                                     activeIcon: String,
                                     inactiveIcon: String) -> UINavigationController {
        let activeImageIcon = UIImage(named: activeIcon)?
            .resized(targetSize: CGSize(width: 30, height: 30))
        let inactiveImageIcon = UIImage(named: inactiveIcon)?
            .resized(targetSize: CGSize(width: 30, height: 30))
        
        let tabBarItem = UITabBarItem(title: title,
                                      image: inactiveImageIcon,
                                      selectedImage: activeImageIcon)
        
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem = tabBarItem
        return navController
    }
    
}

