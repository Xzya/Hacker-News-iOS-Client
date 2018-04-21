//
//  AppDelegate.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/9/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties

    var window: UIWindow?
    static var tabBarController: TabBarController!
    var launchedShortcutItem: Any?

    // MARK: - Delegates

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        self.setup()

        return app(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK: - Helpers

    func setup() {
        ThemeManager.set(theme: ThemeManager.current)
        FontManager.set(font: FontManager.currentFont)
        self.setupTabBarController()
        self.setupWindow()
        self.setupFirebase()
    }

    func setupTabBarController() {
        AppDelegate.tabBarController = TabBarController()
    }

    func setupWindow() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = AppDelegate.tabBarController
        self.window?.makeKeyAndVisible()
    }

    func setupFirebase() {
        FirebaseApp.configure()
    }
}
