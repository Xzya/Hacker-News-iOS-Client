//
//  UserPostsViewController.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/5/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import PromiseKit
import XLPagerTabStrip

class UserPostsViewController: StoriesViewController {

    // MARK: - Properties

    var user: String = ""

    var state: AlgoliaResponse?

    // MARK: - Lifecycle

    init(withUser user: String) {
        self.user = user

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Setup Helpers

    override func setup() {
        super.setup()
        self.setupNavigationItem()

        self.refresh()
    }

    func setupNavigationItem() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    // MARK: - Helpers

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
        guard !self.isFetching else {
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

        HNAPI.userPosts(id: self.user, page: page)
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

extension UserPostsViewController: IndicatorInfoProvider {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Posts")
    }

}

// MARK: - ASTableView

extension UserPostsViewController {

    override func shouldBatchFetch(for tableView: ASTableView) -> Bool {
        return true
    }

}
