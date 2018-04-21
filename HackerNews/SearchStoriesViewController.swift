//
//  SearchPostsViewController.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/6/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit
import PromiseKit
import AsyncDisplayKit
import XLPagerTabStrip

class SearchStoriesViewController: StoriesViewController, HNSearchProtocol {

    // MARK: - Properties

    var query: String = ""
    var sortType: SearchSortType = .relevance
    var timeRangeType: SearchTimeRangeType = .all

    var state: AlgoliaResponse?

    // MARK: - Lifecycle

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Setup Helpers

    override func setup() {
        super.setup()

        self.setupNotificationListener()
    }

    func setupNotificationListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.onRefreshNotificationReceived(notification:)), name: Constants.kSearchNotification.name, object: nil)
    }

    // MARK: - Helpers

    func onRefreshNotificationReceived(notification: Notification) {
        // sort type
        if let sortType = notification.userInfo?["sort"] as? SearchSortType {
            self.sortType = sortType
        }

        // time range type
        if let timeRangeType = notification.userInfo?["timeRange"] as? SearchTimeRangeType {
            self.timeRangeType = timeRangeType
        }

        // query
        if let query = notification.userInfo?["query"] as? String {
            self.query = query

            self.refresh(refreshControl: nil)
        }
    }

    override func refresh(refreshControl: UIRefreshControl? = nil) {
        DispatchQueue.default.async {
            self.state = nil

            // remove all existing items
            self.removeAllRows(completion: { (finished) in
                // load new items
                self.fetchMoreItems(completion: { (finished) in
                    self.refreshControl.endRefreshing()
                    self.isFetching = false
                })
            })
        }
    }

    override func fetchMoreItems(completion: ((Bool) -> ())? = nil) {
        guard !self.isFetching && !self.query.isEmpty else {
            completion?(true)
            return;
        }

        var page = 0

        if let state = self.state {
            if state.page + 1 >= state.pageCount {
                completion?(true)
                return;
            }

            page = state.page + 1
        }

        self.isFetching = true

        HNAPI.searchStories(query: self.query, timeRange: self.timeRangeType, sortBy: self.sortType, page: page)
            .then { result -> Promise<Void> in
                self.state = result

                return ItemProvider.add(items: result.hits)
                    .then { Void -> Void in
                        self.append(items: result.hits, completion: completion)
                }
            }.catch { error in
                print(error) // TODO: - Handle this
                completion?(false)
        }
    }

}

// MARK: - IndicatorInfoProvider

extension SearchStoriesViewController: IndicatorInfoProvider {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Stories")
    }

}

// MARK: - ASTableView

extension SearchStoriesViewController {

    override func shouldBatchFetch(for tableView: ASTableView) -> Bool {
        return !self.query.isEmpty
    }

}
