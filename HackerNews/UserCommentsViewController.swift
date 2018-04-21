//
//  UserCommentsViewController.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/6/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import PromiseKit
import XLPagerTabStrip

class UserCommentsViewController: BaseViewController {

    // MARK: - IBOutlets

    var tableView = HNTableNode()

    // MARK: - Properties

    var refreshControl: UIRefreshControl = UIRefreshControl()

    var isFetching: Bool = false

    var user: String = ""

    var state: AlgoliaResponse?

    var stories: [Int] = []

    // MARK: - Lifecycle

    init(withUser user: String) {
        self.user = user

        super.init(node: self.tableView)

        self.refresh()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }

    // MARK: - Setup Helpers

    func setup() {
        self.setupTableView()
        self.setupPeekPop()
        self.setupNavigationItem()
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

    func setupNavigationItem() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    // MARK: - Helpers

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

        HNAPI.userComments(id: self.user, page: page)
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
                    indexPaths.append(IndexPath(row: self.stories.count, section: 0))
                    self.stories.append(item.id)
                }

                self.tableView.insertRows(at: indexPaths, with: .fade)
                }, completion: completion)
        }
    }

    func removeAllRows(completion: ((Bool) -> ())? = nil) {
        guard self.stories.count > 0 else {
            completion?(true)
            return;
        }

        self.tableView.performBatchUpdates({ 
            var indexPaths: [IndexPath] = []

            for i in (0..<self.stories.count).reversed() {
                indexPaths.append(IndexPath(row: i, section: 0))
                self.stories.removeLast()
            }

            self.tableView.deleteRows(at: indexPaths, with: .fade)
            }, completion: completion)
    }

}

// MARK: - IndicatorInfoProvider

extension UserCommentsViewController: IndicatorInfoProvider {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Comments")
    }

}

// MARK: - ASTableDataSource, ASTableDelegate

extension UserCommentsViewController: ASTableDataSource, ASTableDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stories.count
    }

    func tableView(_ tableView: ASTableView, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            let item = ItemProvider.item(withId: self.stories[indexPath.row])
            let node = UserCommentNode(withItem: item ?? Item())
            node.delegate = self
            return node
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // check if the item is loaded
        if let item = ItemProvider.item(withId: self.stories[indexPath.row]) {
            ItemProvider.read(itemWithId: item.storyId)

            self.navController.push(viewController: CommentsViewController(item: item.storyItem()))
        }

        self.tableView.deselectRow(at: indexPath, animated: true)
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

extension UserCommentsViewController: UIViewControllerPreviewingDelegate {

    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {

        if #available(iOS 9.0, *) {

            // get the indexPath of the cell at the current location
            if let indexPath = self.tableView.indexPathForRow(at: location) {

                // check if the item is loaded
                if let item = ItemProvider.item(withId: self.stories[indexPath.row]) {

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

extension UserCommentsViewController: UserCommentNodeDelegate {

    func userCommentNode(_ userCommentNode: UserCommentNode, didPressLink link: String, withSender sender: ASDisplayNode) {
        self.navController.push(viewController: WebViewController(link: link))
    }

}
