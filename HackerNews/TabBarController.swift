//
//  TabBarController.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/30/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class TabBarController: ASTabBarController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }

    // MARK: - Setup Helpers

    func setup() {
        self.setupTheme()
        self.setupViewControllers()
        self.setupTabBar()
        self.removeTabBarItemsText()
        self.setupDelegate()
    }

    func setupViewControllers() {
        self.viewControllers = [
            NavigationController(rootViewController: HomeViewController()),
            NavigationController(rootViewController: SearchViewController()),
            NavigationController(rootViewController: ProfileViewController()),
            NavigationController(rootViewController: SettingsViewController())
        ]
    }

    func setupTabBar() {
        if let viewControllers = self.viewControllers {
            if viewControllers.count > 0 {
                let icon = IonIcon.image(iconType: .ion_social_hackernews, color: Styles.tabBar.icon)

                viewControllers[0].tabBarItem = UITabBarItem(
                    title: nil,
                    image: icon,
                    selectedImage: icon
                )
            }
            if viewControllers.count > 1 {
                let icon = IonIcon.image(iconType: .ion_search, color: Styles.tabBar.icon)

                viewControllers[1].tabBarItem = UITabBarItem(
                    title: nil,
                    image: icon,
                    selectedImage: icon
                )
            }
            if viewControllers.count > 2 {
                let icon = IonIcon.image(iconType: .ion_person, color: Styles.tabBar.icon)

                viewControllers[2].tabBarItem = UITabBarItem(
                    title: nil,
                    image: icon,
                    selectedImage: icon
                )
            }
            if viewControllers.count > 3 {
                let icon = IonIcon.image(iconType: .ion_ios_cog, color: Styles.tabBar.icon)

                viewControllers[3].tabBarItem = UITabBarItem(
                    title: nil,
                    image: icon,
                    selectedImage: icon
                )
            }
        }
    }

    func setupDelegate() {
        self.delegate = self
    }

    // MARK: - Helpers

    func removeTabBarItemsText() {
        if let items = tabBar.items {
            for item in items {
                item.title = ""
                item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
            }
        }
    }

}

// MARK: - UITabBarDelegate

extension TabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let viewControllers = self.viewControllers {
            // home
            if tabBarController.selectedIndex == 0 {
                // make sure first view controller is a navigation controller
                ((viewControllers[safe: 0] as? NavigationController)?
                    // make sure the first view controller in the navigation controller is home
                    .viewControllers[safe: 0] as? HomeViewController)?
                    // scroll to top
                    .tableView.view.setContentOffset(CGPoint.zero, animated: true)
            }
        }
        return true
    }
    
}
