//
//  NavigationController.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/9/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit
import AMScrollingNavbar

class NavigationController: ScrollingNavigationController {

    // MARK: - Inits

    init() {
        super.init(rootViewController: HomeViewController())

        self.setup()
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)

        self.setup()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.setup()
    }

    // MARK: - Setup Helpers

    func setup() {
        self.setupTheme()
    }

    // MARK: - Helpers

    func push(viewController: UIViewController, animated: Bool = true) {
        self.pushViewController(viewController, animated: animated)
    }

    func pop(toViewControllerOfType type: AnyClass, animated: Bool = true) -> Bool {
        for viewController in self.viewControllers {
            if viewController.classForCoder == type {
                let _ = self.popToViewController(viewController, animated: animated)
                return true
            }
        }
        return false
    }

    func back(animated: Bool = true) {
        let _ = self.popViewController(animated: animated)
    }

    func displayHome(animated: Bool = true) {
        if !self.pop(toViewControllerOfType: HomeViewController.classForCoder(), animated: animated) {
            self.push(viewController: HomeViewController(), animated: animated)
        }
    }

    func present(viewController: UIViewController, animated: Bool = true, completionHandler handler: (() -> Void)? = nil) {
        self.present(viewController: viewController, animated: animated, completionHandler: handler)
    }

}
