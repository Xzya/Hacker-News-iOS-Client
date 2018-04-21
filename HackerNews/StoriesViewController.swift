//
//  StoryViewController.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/5/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class StoriesViewController: BaseViewController {

    // MARK: - IBOutlets

    var tableView = HNTableNode()

    // MARK: - Properties

    var refreshControl: UIRefreshControl = UIRefreshControl()

    var storyList: [Int] = []
    var stories: [Int] = []

    var storiesSection: Int {
        return 0
    }

    var isFetching: Bool = false

    // MARK: - Lifecycle

    init() {
        super.init(node: self.tableView)
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

    // MARK: - Helpers

    func refresh(refreshControl: UIRefreshControl? = nil) {
        DispatchQueue.default.async {
            // remove all existing items
            self.removeAllRows(completion: { (finished) in
                // load new items
                self.fetchMoreItems(completion: { (finished) in
                    self.refreshControl.endRefreshing()
                })
            })
        }
    }

    func fetchMoreItems(completion: ((Bool) -> ())? = nil) {
        self.append(items: [], completion: completion)
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
                    indexPaths.append(IndexPath(row: self.stories.count, section: self.storiesSection))
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
                indexPaths.append(IndexPath(row: i, section: storiesSection))
                self.stories.removeLast()
            }

            self.tableView.deleteRows(at: indexPaths, with: .fade)
            }, completion: completion)
    }

}

// MARK: - ASTableDataSource, ASTableDelegate

extension StoriesViewController: ASTableDataSource, ASTableDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stories.count
    }

    func tableView(_ tableView: ASTableView, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            let item = ItemProvider.item(withId: self.stories[indexPath.row])
            return StoryNode(withItem: item ?? Item(), storyNodeDelegate: self, storyBarDelegate: self)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // check if the item is loaded
        if let item = ItemProvider.item(withId: self.stories[indexPath.row]) {
            ItemProvider.read(itemWithId: item.id)

            // check if the item has an url
            // if so, open the web view
            if !item.url.isEmpty {
                self.navController.push(viewController: WebViewController(item: item))
            } else {
                // otherwise, open the comments screen
                self.navController.push(viewController: CommentsViewController(item: item))
            }

            self.tableView.reloadRows(at: [indexPath], with: .fade)
        }

        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    func shouldBatchFetch(for tableView: ASTableView) -> Bool {
        return self.stories.count < self.storyList.count
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
        self.showNavbar(animated: true)
        return true
    }

}

// MARK: - StoryNodeDelegate

extension StoriesViewController: StoryNodeDelegate {

    func storyNode(_ storyNode: StoryNode, didPressOnPosterButton sender: ASDisplayNode) {
        if let indexPath = self.tableView.indexPath(for: storyNode) {
            if let item = ItemProvider.item(withId: self.stories[indexPath.row]) {
                self.navController.push(viewController: UserViewController(withUser: item.by))
            }
        }
    }

}

// MARK: - StoryBarDelegate

extension StoriesViewController: StoryBarDelegate {

    func storyBar(_ storyBar: StoryBarNode, didPressShareButtonWithSender sender: ASDisplayNode) {
        if let item = ItemProvider.item(withId: storyBar.itemId) {
            ShareHelper.share(items: item.shareContent(), fromViewController: self, sourceView: sender.view)
        }
    }

    func storyBar(_ storyBar: StoryBarNode, didPressCommentsButtonWithSender sender: ASDisplayNode) {
        if let item = ItemProvider.item(withId: storyBar.itemId) {
            // mark the item as read
            ItemProvider.read(itemWithId: item.id)
            // try to locate the index path of the cell an reload it
            if let index = self.stories.index(of: item.id) {
                let indexPath = IndexPath(row: index, section: self.storiesSection)
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }

            self.navController.push(viewController: CommentsViewController(item: item))
        }
    }

    func storyBar(_ storyBar: StoryBarNode, didPressVoteButtonWithSender sender: ASDisplayNode) {
        if self.authenticated() {
            if let item = ItemProvider.item(withId: storyBar.itemId) {
                let up = !ItemProvider.didVote(item: item)
                up ? ItemProvider.vote(item: item) : ItemProvider.removeVote(item: item)

                storyBar.set(upvoted: up)

                HNAPI.vote(item: item, up: up)
                    .then { Void -> Void in
                        print("Voted \(item.id)")
                    }.catch { error in
                        up ? ItemProvider.removeVote(item: item) : ItemProvider.vote(item: item)
                        print(error) // TODO: - Handle this
                }
            }
        }
    }

}

// MARK: - UIViewControllerPreviewingDelegate

extension StoriesViewController: UIViewControllerPreviewingDelegate {

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

                    // check if the item has an url
                    // if so, open the web view
                    if !item.url.isEmpty {
                        return WebViewController(item: item)
                    } else {
                        // otherwise, open the comments screen
                        return CommentsViewController(item: item)
                    }
                }
            }
        }

        return nil
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navController.push(viewController: viewControllerToCommit)
    }

}
