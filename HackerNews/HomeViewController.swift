//
//  HomeViewController.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/9/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import PromiseKit

class HomeViewController: StoriesViewController {

    // MARK: - Properties

    var storyType: StoryType = SettingsProvider.storyType

    /// This array holds items which expired and have been reloaded
    /// The expired items will only be reloaded once after the user
    /// pulls to refresh
    var reloadedExpiredItems: [Int] = []

    override var storiesSection: Int {
        return 1
    }

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.setupTabBar()
        self.navigationController(followScrollView: self.tableView.view, delay: 50)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.showNavbar(animated: false)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.stopFollowingScrollView()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Setup Helpers

    override func setup() {
        super.setup()

        self.storyList = ItemProvider.stories(ofType: self.storyType)

        self.title = "Hacker News"
        self.setupNavigationItem()
        self.setupNotificationListener()
        self.refresh()
    }

    func setupNavigationItem() {
        // TODO: - uncomment when post story is supported
//        self.navigationItem.set(leftButtonIcon: .ion_edit, target: self, action: #selector(self.onPostStoryButtonPressed))
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    func setupTabBar() {
        self.navController.tabBarItem.title = nil
    }

    func setupNotificationListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.onClearCacheNotificationReceived), name: Constants.kClearCacheNotification.name, object: nil)
    }

    // MARK: - Helpers

    func onClearCacheNotificationReceived() {
        self.removeAllRows()
    }

    override func refresh(refreshControl: UIRefreshControl? = nil) {
        self.reloadedExpiredItems.removeAll()

        DispatchQueue.default.async {
            HNAPI.stories(ofType: self.storyType)
                .then { result -> Void in

                    // save the story list
                    ItemProvider.set(stories: result, forType: self.storyType)
                    self.storyList = result

                    // remove all existing items
                    self.removeAllRows(completion: { (finished) in
                        // load new items
                        self.fetchMoreItems(completion: { (finished) in
                            self.isFetching = false
                        })
                    })

                }.always {
                    self.refreshControl.endRefreshing()
                }.catch { error in
                    print(error) // TODO: - Handle this
            }
        }
    }

    func shouldReloadExpiredItem(withId id: Int) -> Bool {
        return !self.reloadedExpiredItems.contains(id)
    }

    override func fetchMoreItems(completion: ((Bool) -> ())? = nil) {
        // make sure we have items in the list
        guard self.storyList.count > self.stories.count && !self.isFetching else {
            completion?(true)
            return;
        }

        self.isFetching = true

        // make sure we won't go out of bounds
        let maxItem = min(self.stories.count + Constants.kHomePreloadItemCount, self.storyList.count)

        var callStack: [Promise<Item>] = []

        for i in self.stories.count..<maxItem {

            // only load the item if we don't already have it
            // or if we have it but it expired

            // check if we already have this item loaded
            guard let item = ItemProvider.item(withId: self.storyList[i]) else {
                callStack.append(HNAPI.item(id: self.storyList[i]))
                continue;
            }

            // check if we should load expired items
            if self.shouldReloadExpiredItem(withId: item.id) {

                // check if it expired
                if NSDate().timeIntervalSince(item.dateAdded) > Constants.kItemExpiratinTime {

                    self.reloadedExpiredItems.append(self.storyList[i])

                    // load it again
                    callStack.append(HNAPI.item(id: self.storyList[i]))
                    continue;
                }
            }

            // if the item we already have is fine, just return it
            callStack.append(Promise(value: item))
        }

        // when all the promises are fulfilled
        when(fulfilled: callStack)
            .then { result -> Void in
                ItemProvider.add(items: result).then { () -> Void in
                    // add all the items to the table
                    self.append(items: result, completion: completion)
                    }.catch { error in
                        print(error)
                        completion?(false)
                }
            }.catch { error in
                print(error) // TODO: - Handle this
                completion?(false)
        }
    }

    // MARK: - IBActions

    func onPostStoryButtonPressed() {

        // make sure we're authenticated
        if self.authenticated() {

            // show the post story controller
            self.present(NavigationController(rootViewController: HNPostStoryController()), animated: true, completion: nil)
            
        }
    }

}

// MARK: - ASTableDataSource, ASTableDelegate

extension HomeViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }

    override func tableView(_ tableView: ASTableView, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            switch indexPath.section {
            case 0:
                return StoryTypeNode(withTitle: self.storyType.title)

            default:
                let item = ItemProvider.item(withId: self.stories[indexPath.row])
                return StoryNode(withItem: item ?? Item(), storyNodeDelegate: self, storyBarDelegate: self)

            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            AppDelegate.tabBarController.present(OptionsViewController(delegate: self), animated: true, completion: nil)

            self.tableView.deselectRow(at: indexPath, animated: true)

        default:
            super.tableView(tableView, didSelectRowAt: indexPath)

        }
    }

}

// MARK: - OptionSelectViewDelegate

/**
 * There are 2 sections.
 * Cancel
 * Options
 */
enum HomeSectionType: Int {
    case options = 0
    case cancel = 1

    static var count: Int {
        return 2
    }
}

extension HomeViewController: OptionSelectViewDelegate {

    func numberOfSections(in optionSelectView: OptionsViewController) -> Int {
        return HomeSectionType.count
    }

    func optionSelectView(optionSelectView: OptionsViewController, numberOfItemsInSection section: Int) -> Int {

        guard let sectionType = HomeSectionType(rawValue: section) else {
            assertionFailure("Home section \(section) not found.")
            return -1
        }

        // check section
        switch sectionType {

        // cancel
        case .cancel:
            return 1

        // options
        case .options:
            return StoryType.values.count
        }

    }

    func optionSelectView(optionSelectView: OptionsViewController, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {

            guard let sectionType = HomeSectionType(rawValue: indexPath.section) else {
                assertionFailure("Home section \(indexPath.section) not found.")
                return ASCellNode()
            }

            // check section
            switch sectionType {

            // cancel
            case .cancel:
                return HNOptionActionNode(optionType: GeneralType.cancel)

            // options
            case .options:
                return OptionSelectNode(
                    optionType: StoryType.values[indexPath.row],
                    selected: StoryType.values[indexPath.row] == self.storyType
                )

            }
        }
    }

    func optionSelectView(optionSelectView: OptionsViewController, didSelectItemAtIndexPath indexPath: IndexPath) {

        guard let sectionType = HomeSectionType(rawValue: indexPath.section) else {
            assertionFailure("Home section \(indexPath.section) not found.")
            return;
        }

        // check section
        switch sectionType {

        // cancel
        case .cancel:
            return;

        // options
        case .options:

            // make sure we're not out of range
            if indexPath.row <= StoryType.values.count {

                // if we didn't select the same story type
                if self.storyType != StoryType.values[indexPath.row] {

                    // save the story type
                    self.storyType = StoryType.values[indexPath.row]

                    // reload the row
                    self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .fade)

                    // refresh the items
                    self.refresh()
                }
            }
        }
    }

}
