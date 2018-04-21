//
//  3DTouchHelper.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/16/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit

extension AppDelegate {

    // MARK: - Properties

    static func applicationShortcutUserInfoIconKey() -> String {
        return "applicationShortcutUserInfoIconKey"
    }

    // MARK: - Types

    enum ShortcutIdentifier: String {
        case post
        case inbox
        case search

        // MARK: - Initializers

        init?(fullType: String) {
            guard let last = fullType.components(separatedBy: ".").last else { return nil }

            self.init(rawValue: last)
        }

        // MARK: - Properties

        var type: String {
            return Bundle.main.bundleIdentifier! + ".\(self.rawValue)"
        }
    }

    // MARK: - Helpers

    @available(iOS 9.0, *)
    func handleShortCutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
        var handled = false

        // Verify that the provided `shortcutItem`'s `type` is one handled by the application.
        guard ShortcutIdentifier(fullType: shortcutItem.type) != nil else { return false }

        guard let shortCutType = shortcutItem.type as String? else { return false }

        switch (shortCutType) {
        case ShortcutIdentifier.post.type:
            handled = true
            break
        case ShortcutIdentifier.inbox.type:
            handled = true
            break
        case ShortcutIdentifier.search.type:
            handled = true
            break
        default:
            break
        }

        // Construct an alert using the details of the shortcut used to open the application.
        let alertController = UIAlertController(title: "Shortcut Handled", message: "\"\(shortcutItem.localizedTitle)\"", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)

        // Display an alert indicating the shortcut selected from the home screen.
        window!.rootViewController?.present(alertController, animated: true, completion: nil)

        return handled
    }

    func app(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 9.0, *) {
            // Override point for customization after application launch.
            var shouldPerformAdditionalDelegateHandling = true

            // If a shortcut was launched, display its information and take the appropriate action
            if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {

                launchedShortcutItem = shortcutItem

                // This will block "performActionForShortcutItem:completionHandler" from being called.
                shouldPerformAdditionalDelegateHandling = false
            }

            // Install initial versions of our two extra dynamic shortcuts.
            if let shortcutItems = application.shortcutItems, shortcutItems.isEmpty {
                // Construct the items.
                let shortcut1 = UIMutableApplicationShortcutItem(type: ShortcutIdentifier.post.type, localizedTitle: "Post", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .add), userInfo: [
                    AppDelegate.applicationShortcutUserInfoIconKey(): UIApplicationShortcutIconType.add.rawValue
                    ]
                )

                var shortcut2: UIMutableApplicationShortcutItem!

                if #available(iOS 9.1, *) {
                    shortcut2 = UIMutableApplicationShortcutItem(type: ShortcutIdentifier.inbox.type, localizedTitle: "Inbox", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .mail), userInfo: [
                        AppDelegate.applicationShortcutUserInfoIconKey(): UIApplicationShortcutIconType.mail.rawValue
                        ]
                    )
                } else {
                    shortcut2 = UIMutableApplicationShortcutItem(type: ShortcutIdentifier.inbox.type, localizedTitle: "Inbox", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .compose), userInfo: [
                        AppDelegate.applicationShortcutUserInfoIconKey(): UIApplicationShortcutIconType.compose.rawValue
                        ]
                    )
                }

                let shortcut3 = UIMutableApplicationShortcutItem(type: ShortcutIdentifier.inbox.type, localizedTitle: "Search", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .search), userInfo: [
                    AppDelegate.applicationShortcutUserInfoIconKey(): UIApplicationShortcutIconType.search.rawValue
                    ]
                )

                // Update the application providing the initial 'dynamic' shortcut items.
                application.shortcutItems = [shortcut1, shortcut2, shortcut3]
            }

            return shouldPerformAdditionalDelegateHandling
        }
        return true
    }

    // MARK: - Application Life Cycle

    func applicationDidBecomeActive(_ application: UIApplication) {
        if #available(iOS 9.0, *) {
            guard let shortcut = launchedShortcutItem as? UIApplicationShortcutItem else { return }
            let _ = handleShortCutItem(shortcutItem: shortcut)

            launchedShortcutItem = nil
        }
    }

    @objc(application:performActionForShortcutItem:completionHandler:) @available(iOS 9.0, *)
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let handledShortCutItem = handleShortCutItem(shortcutItem: shortcutItem)

        completionHandler(handledShortCutItem)
    }

}
