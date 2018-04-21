//
//  BaseViewController.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/9/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit
import AMScrollingNavbar
import MBProgressHUD
import AsyncDisplayKit

class BaseViewController: ASViewController<ASDisplayNode> {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTheme()
    }

    // MARK: - Properties

    override var nibName: String? {
        get {
            //            return self.classForCoder.description().components(separatedBy: ".").last ?? super.nibName
            return nil
        }
    }

    var navController: NavigationController {
        return self.navigationController as! NavigationController
    }

    // MARK: - Helpers

    func authenticated() -> Bool {
        if !User.sharedInstance.isLoggedIn() {
            self.present(AuthViewController(state: .login), animated: true, completion: nil)
            return false
        }
        return true
    }

}

extension BaseViewController {

    func navigationController(followScrollView scrollView: UIView, delay: Double) {
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(scrollView, delay: delay)
        }
    }

    func stopFollowingScrollView() {
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.stopFollowingScrollView()
        }
    }

    func showNavbar(animated: Bool = true) {
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: animated)
        }
    }

}

extension BaseViewController {

    func showLoader() {
        MBProgressHUD.showLoader(view: self.view)
    }

    func hideLoader() {
        MBProgressHUD.hideLoader(view: self.view)
    }

}
