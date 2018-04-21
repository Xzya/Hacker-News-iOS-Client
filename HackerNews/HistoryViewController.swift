//
//  HistoryViewController.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/5/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import PromiseKit

class HistoryViewController: StoriesViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }

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

        self.storyList = ItemProvider.readItems

        self.title = "History"
        self.setupNavigationItem()
        self.setupNotificationListener()
    }

    func setupNavigationItem() {
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
        self.storyList.removeAll()
        self.removeAllRows()
    }

    override func refresh(refreshControl: UIRefreshControl? = nil) {
        DispatchQueue.default.async {

            self.storyList = ItemProvider.readItems

            // remove all existing items
            self.removeAllRows(completion: { (finished) in
                // load new items
                self.fetchMoreItems(completion: { (finished) in
                    self.isFetching = false
                    self.refreshControl.endRefreshing()
                })
            })
        }
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
            // check if we already have this item loaded
            guard let item = ItemProvider.item(withId: self.storyList[i]) else {
                callStack.append(HNAPI.item(id: self.storyList[i]))
                continue;
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

}
