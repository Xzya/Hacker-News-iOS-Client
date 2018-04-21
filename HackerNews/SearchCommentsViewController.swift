//
//  SearchCommentsViewController.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/6/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import PromiseKit
import XLPagerTabStrip

class SearchCommentsViewController: BaseViewController, HNSearchProtocol {

    // MARK: - IBOutlets

    var tableView = HNTableNode()

    // MARK: - Properties

    var refreshControl: UIRefreshControl = UIRefreshControl()

    var query: String = ""
    var sortType: SearchSortType = .relevance
    var timeRangeType: SearchTimeRangeType = .all

    var state: AlgoliaResponse?

    var isFetching: Bool = false

    var comments: [Int] = []

    // MARK: - Lifecycle

    init() {
        super.init(node: self.tableView)

        self.setupNotificationListener()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Setup Helpers

    func setup() {
        self.setupTableView()
        self.setupPeekPop()
    }

    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.refreshControl.addTarget(self, action: #selector(self.refresh(refreshControl:)), for: .valueChanged)
        self.tableView.view.addSubview(self.refreshControl)
    }

    func setupPeekPop() {
        if #available(iOS 9.0, *) {
            if self.traitCollection.forceTouchCapability == .available {
                self.registerForPreviewing(with: self, sourceView: self.view)
            }
        }
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

    func refresh(refreshControl: UIRefreshControl? = nil) {
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

    func fetchMoreItems(completion: ((Bool) -> ())? = nil) {
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

        HNAPI.searchComments(query: self.query, timeRange: self.timeRangeType, sortBy: self.sortType, page: page)
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

    func append(items: [Item], completion: ((Bool) -> ())? = nil) {
        guard items.count > 0 else {
            completion?(true)
            return;
        }

        DispatchQueue.main.async {
            self.tableView.performBatchUpdates({ 
                var indexPaths: [IndexPath] = []

                for item in items {
                    indexPaths.append(IndexPath(row: self.comments.count, section: 0))
                    self.comments.append(item.id)
                }

                self.tableView.insertRows(at: indexPaths, with: .fade)
                }, completion: completion)
        }
    }

    func removeAllRows(completion: ((Bool) -> ())? = nil) {
        guard self.comments.count > 0 else {
            completion?(true)
            return;
        }

        self.tableView.performBatchUpdates({ 
            var indexPaths: [IndexPath] = []

            for i in (0..<self.comments.count).reversed() {
                indexPaths.append(IndexPath(row: i, section: 0))
                self.comments.removeLast()
            }

            self.tableView.deleteRows(at: indexPaths, with: .fade)
            }, completion: completion)
    }

}

// MARK: - IndicatorInfoProvider

extension SearchCommentsViewController: IndicatorInfoProvider {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Comments")
    }

}

// MARK: - ASTableDataSource, ASTableDelegate

extension SearchCommentsViewController: ASTableDataSource, ASTableDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }

    func tableView(_ tableView: ASTableView, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            let item = ItemProvider.item(withId: self.comments[indexPath.row])
            let node = UserCommentNode(withItem: item ?? Item())
            node.delegate = self
            return node
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // check if the item is loaded
        if let item = ItemProvider.item(withId: self.comments[indexPath.row]) {
            ItemProvider.read(itemWithId: item.storyId)

            self.navController.push(viewController: CommentsViewController(item: item.storyItem()))
        }

        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    func shouldBatchFetch(for tableView: ASTableView) -> Bool {
        return true
    }

    func tableView(_ tableView: ASTableView, willBeginBatchFetchWith context: ASBatchContext) {
        if !self.isFetching {
            self.fetchMoreItems { (finished) in
                context.completeBatchFetching(true)
                self.isFetching = false
            }
        } else {
            context.completeBatchFetching(true)
        }
    }

    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }

}

// MARK: - UIViewControllerPreviewingDelegate

extension SearchCommentsViewController: UIViewControllerPreviewingDelegate {

    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {

        if #available(iOS 9.0, *) {

            // get the indexPath of the cell at the current location
            if let indexPath = self.tableView.indexPathForRow(at: location) {

                // check if the item is loaded
                if let item = ItemProvider.item(withId: self.comments[indexPath.row]) {

                    // get the cell rect and convert it to the view coordinate space
                    let cellRect = self.tableView.rectForRow(at: indexPath)
                    let convertedRect = self.tableView.view.convert(cellRect, to: self.view)

                    // set the source rect to the cell rect
                    previewingContext.sourceRect = convertedRect

                    // open the comments screen
                    return CommentsViewController(item: item.storyItem())
                }
            }
        }

        return nil
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navController.push(viewController: viewControllerToCommit)
    }

}

// MARK: - UserCommentNodeDelegate

extension SearchCommentsViewController: UserCommentNodeDelegate {

    func userCommentNode(_ userCommentNode: UserCommentNode, didPressLink link: String, withSender sender: ASDisplayNode) {
        self.navController.push(viewController: WebViewController(link: link))
    }

}
