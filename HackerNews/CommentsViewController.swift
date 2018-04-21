//
//  CommentsViewController.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/15/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit
import AsyncDisplayKit

enum CommentsOptionSelectType {
    case navigationRight
    case comment
}

class CommentsViewController: BaseViewController {

    // MARK: - IBOutlets

    var tableView = CommentsTableView()

    let backView = CommentsTableBackgroundView(frame: .zero)

    var storyBarNode: StoryBarNode!

    // MARK: - Properties

    var refreshControl = UIRefreshControl()

    var item: Item = Item()
    var comments: [Item] = []

    var optionSelectType: CommentsOptionSelectType?
    var optionSelectItem: Item?

    var isFetching: Bool = false

    private var contentSizeContext = 0

    // MARK: - Lifecycle

    init(item: Item) {
        super.init(node: self.tableView)

        self.item = item
        self.hidesBottomBarWhenPushed = true

        self.setupStoryBarNode()

        if !self.item.isLoaded {
            self.refresh()
        } else {
            self.fetchMoreItems(completion: { _ in
                self.isFetching = false
            })
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
    }

    deinit {
        self.tableView.view.removeObserver(self, forKeyPath: "contentSize")
    }

    // MARK: - Setup Helpers

    func setup() {
        self.setupTableView()
        self.setupBackView()
        self.setupNavigationItem()
    }

    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.setupTheme()

        self.refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        self.tableView.view.addSubview(self.refreshControl)
    }

    func setupStoryBarNode() {
        self.storyBarNode = StoryBarNode(withItem: self.item)
        self.storyBarNode.delegate = self

        self.storyBarNode.style.width = .init(unit: .fraction, value: 1)
        self.storyBarNode.style.height = .init(unit: .points, value: HNDimensions.itemBar.height)
    }

    func setupNavigationItem() {
        self.navigationItem.set(rightButtonIcon: .ion_more, target: self, action: #selector(self.onNavigationRightButtonPressed))
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    func setupBackView() {
        self.view.addSubview(self.backView)
        self.view.sendSubview(toBack: self.backView)

        self.tableView.view.addObserver(self, forKeyPath: "contentSize", options: .new, context: &self.contentSizeContext)
    }

    // MARK: - Helpers

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // update the backview size if the table's contentSize was updated
        if context == &contentSizeContext {
            self.backView.frame.size = self.tableView.view.contentSize
        }
    }

    func refresh(refreshControl: UIRefreshControl? = nil) {
        DispatchQueue.default.async {
            HNAPI.itemDetails(id: self.item.id)
                .then { result -> Void in
                    // save the item
                    self.item = result
                    let _ = ItemProvider.add(item: self.item)

                    self.comments.removeAll()
                    self.comments = self.getMoreItems()

                    // remove the selected index paths
                    self.tableView.selectedIndexPaths = []

                    // remove the collapsed index paths
                    self.tableView.collapsedIndexPaths = []

                    self.tableView.reloadData()

                    self.isFetching = false

                }.always {
                    self.refreshControl.endRefreshing()
                }.catch { error in
                    print(error) // TODO: - Handle this
            }
        }
    }

    func getMoreItems() -> [Item] {
        // make sure we have more items in the list
        guard self.item.children.count > self.comments.count else {
            return []
        }

        // make sure we won't go out of bounds
        let maxItem = min(self.comments.count + Constants.kCommentsPreloadItemCount, self.item.children.count)

        // slice the part that we need
        let itemsToAppend = Array(self.item.children[self.comments.count..<maxItem])

        return itemsToAppend
    }

    func fetchMoreItems(completion: ((Bool) -> ())? = nil) {
        // make sure we have more items in the list
        guard !self.isFetching else {
            completion?(true)
            return;
        }

        self.isFetching = true

        // add the items to the table
        self.append(items: self.getMoreItems(), completion: completion)
    }

    func removeAllRows(completion: ((Bool) -> ())? = nil) {
        // make sure we have comments to remove
        guard self.comments.count > 0 else {
            completion?(true)
            return;
        }

        // begin updates
        self.tableView.performBatchUpdates({ 
            // build the index path array
            var indexPaths: [IndexPath] = []

            for i in (0..<self.comments.count).reversed() {
                indexPaths.append(IndexPath(row: 0, section: i + 1))
                self.comments.removeLast()
            }

            // add the selected index paths if we have any
            indexPaths.append(contentsOf: self.tableView.selectedIndexPaths.reduce([], { (result, indexPath) -> [IndexPath] in
                return result + [IndexPath(row: indexPath.row + 1, section: indexPath.section)]
            }))

            // delete the rows
            self.tableView.deleteRows(at: indexPaths, with: .fade)
            }, completion: completion)
    }

    func append(items: [Item], completion: ((Bool) -> ())? = nil) {
        // create the index set of new sections
        let startIndex = self.comments.count + 1
        let endIndex = startIndex + items.count

        let indexSet = IndexSet.init(integersIn: Range(uncheckedBounds: (startIndex, endIndex)))

        DispatchQueue.main.async {
            // begin updates
            self.tableView.performBatchUpdates({ 
                // add the new comments
                self.comments.append(contentsOf: items)

                // insert the sections
                self.tableView.insertSections(indexSet, with: .fade)
                }, completion: completion)
        }
    }

    func reload(withItems items: [Item], completion: ((Bool) -> ())? = nil) {
        guard items.count > 0 else {
            completion?(true)
            return;
        }

        self.tableView.performBatchUpdates({ 
            var reloadIndexPaths: [IndexPath] = []
            var insertIndexpaths: [IndexPath] = []
            var deleteIndexPaths: [IndexPath] = []

            if items.count >= self.comments.count {
                if self.comments.count > 0 {
                    for i in 1...(self.comments.count) {
                        reloadIndexPaths.append(IndexPath(row: 0, section: i))
                    }
                }
                if (self.comments.count + 1) <= (items.count) {
                    for i in (self.comments.count + 1)...(items.count) {
                        insertIndexpaths.append(IndexPath(row: 0, section: i))
                    }
                }
            } else {
                if items.count > 0 {
                    for i in 1...(items.count) {
                        reloadIndexPaths.append(IndexPath(row: 0, section: i))
                    }
                }
                if (items.count + 1) <= (self.comments.count) {
                    for i in (items.count + 1)...(self.comments.count) {
                        deleteIndexPaths.append(IndexPath(row: 0, section: i))
                    }
                }
            }

            // delete the selected index paths if we have them
            if self.tableView.selectedIndexPaths.count > 0 {
                var selectedIndexPaths: [IndexPath] = []

                for selectedIndexPath in self.tableView.selectedIndexPaths {
                    selectedIndexPaths.append(IndexPath(row: 1, section: selectedIndexPath.section))
                }

                deleteIndexPaths.append(contentsOf: selectedIndexPaths)
            }

            self.comments = items

            if reloadIndexPaths.count > 0 {
                self.tableView.reloadRows(at: reloadIndexPaths, with: .fade)
            }

            if insertIndexpaths.count > 0 {
                self.tableView.insertRows(at: insertIndexpaths, with: .fade)
            }
            
            if deleteIndexPaths.count > 0 {
                self.tableView.deleteRows(at: deleteIndexPaths, with: .fade)
            }
            }, completion: completion)
    }

    // MARK: - IBActions

    func onNavigationRightButtonPressed() {
        self.optionSelectType = .navigationRight
        AppDelegate.tabBarController.present(OptionsViewController(delegate: self), animated: true, completion: nil)
    }

}

// MARK: - ASTableDataSource, ASTableDelegate

extension CommentsViewController: ASTableDataSource, ASTableDelegate {

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return self.storyBarNode.view
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return HNDimensions.itemBar.height
        }
        return 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.comments.count + 1 // + 1 for item detail
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1

        default:
            for selectedIndexPath in self.tableView.selectedIndexPaths {
                if selectedIndexPath.section == section {
                    return 2
                }
            }

            return 1
        }
    }

    func tableView(_ tableView: ASTableView, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {

        switch indexPath.section {
        // first section is the item detail
        case 0:
            return {
                return StoryDetailNode(withItem: self.item, delegate: self)
            }

        default:
            switch indexPath.row {
            // first row in other sections is the comment
            case 0:
                let comment = self.comments[indexPath.section - 1]

                return {
                    return CommentNode(withItem: comment, delegate: self)
                }

            default:
                // second row is the comment options
                let comment = self.comments[indexPath.section - 1]

                return {
                    return CommentOptionsNode(withItem: comment, commentOptionsDelegate: self)
                }
            }
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)

        // make sure this is not the story details row
        // also not a comment options row
        guard indexPath.section != 0 && indexPath.row != 1 else {
            return;
        }

        // make sure the selected comment is not deleted
        let item = self.comments[indexPath.section - 1]
        guard item.type != .none else {
            return;
        }

        // make sure the selected comment is not collapsed
        guard !self.tableView.collapsedIndexPaths.contains(indexPath) else {
            return;
        }

        // check if the row is already selected
        if let index = self.tableView.selectedIndexPaths.index(of: indexPath) {
            // deselect it
            self.tableView.deselectRow(at: indexPath, animated: true)
            // remove it from the list
            self.tableView.selectedIndexPaths.remove(at: index)
            self.tableView.deleteRows(at: [IndexPath.init(row: indexPath.row + 1, section: indexPath.section)], with: .fade)
        } else {
            // else, add it to the list
            self.tableView.selectedIndexPaths.append(indexPath)
            self.tableView.insertRows(at: [IndexPath.init(row: indexPath.row + 1, section: indexPath.section)], with: .fade)
        }
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

}

// MARK: - CommentNodeDelegate

extension CommentsViewController: CommentNodeDelegate {

    func commentNode(_ commentNode: CommentNode, didPressExpandButtonWithSender sender: ASDisplayNode, expanded: Bool) {
        if let indexPath = self.tableView.indexPath(for: commentNode) {
            // check if the cell is expanded
            if expanded {
                // get the index of the index path
                if let index = self.tableView.collapsedIndexPaths.index(of: indexPath) {
                    // remove it
                    self.tableView.collapsedIndexPaths.remove(at: index)
                }

                // expand subcomments
                self.toggleCollapsedSubcomments(fromIndex: indexPath.section - 1, collapse: false)

            } else {
                // else, make sure we don't already have it
                if !self.tableView.collapsedIndexPaths.contains(indexPath) {
                    // add it
                    self.tableView.collapsedIndexPaths.append(indexPath)
                }

                // collapse subcomments
                self.toggleCollapsedSubcomments(fromIndex: indexPath.section - 1, collapse: true)

                // check if we have an options view
                if let index = self.tableView.selectedIndexPaths.index(of: indexPath) {
                    // remove it
                    self.tableView.selectedIndexPaths.remove(at: index)

                    // delete it from the table
                    self.tableView.deleteRows(at: [IndexPath(row: 1, section: indexPath.section)], with: .fade)
                }
            }
        }
    }

    func commentNode(_ commentNode: CommentNode, didPressPosterButtonWithSender sender: ASDisplayNode) {
        if let indexPath = self.tableView.indexPath(for: commentNode) {
            self.navController.push(viewController: UserViewController(withUser: self.comments[indexPath.section - 1].by))
        }
    }

    func commentNode(_ commentNode: CommentNode, didPressLink link: String, withSender sender: ASDisplayNode) {
        self.navController.push(viewController: WebViewController(link: link))
    }

    func toggleCollapsedSubcomments(fromIndex index: Int, collapse: Bool) {
        // get the root comment
        let rootComment = self.comments[index]

        // start at the next comment
        let startIndex = index + 1

        // make sure we have more comments
        guard startIndex < self.comments.count else { return }

        // loop trought all comments starting with the next comment
        for i in startIndex..<self.comments.count {

            // if the comment has a higher level than the root comment
            if self.comments[i].level > rootComment.level {

                let subcommentIndexPath = IndexPath(row: 0, section: i + 1)

                // get the cell
                if let commentNode = self.tableView.nodeForRow(at: subcommentIndexPath) as? CommentNode {

                    if collapse {
                        commentNode.setParentCollapsed()
                    } else {
                        // if the node was collapsed as well, remove it from the list so we can expand it
                        if let index = self.tableView.collapsedIndexPaths.index(of: subcommentIndexPath) {
                            // remove it
                            self.tableView.collapsedIndexPaths.remove(at: index)
                        }

                        commentNode.setParentExpanded()
                        commentNode.setExpanded()
                    }
                    commentNode.layoutIfNeeded()

                    // check if we have an options view for the comment
                    if let index = self.tableView.selectedIndexPaths.index(of: subcommentIndexPath) {
                        // remove it
                        self.tableView.selectedIndexPaths.remove(at: index)

                        // delete it from the table
                        self.tableView.deleteRows(at: [IndexPath(row: 1, section: subcommentIndexPath.section)], with: .fade)
                    }
                }

            }
            // otherwise, stop since we checked all subcomments
            else {
                break
            }
        }

    }

}

// MARK: - CommentOptionsNodeDelegate

extension CommentsViewController: CommentOptionsNodeDelegate {

    func commentOptions(_ commentOptions: CommentOptionsNode, didPressMoreButtonWithSender sender: ASDisplayNode) {
        self.optionSelectItem = commentOptions.item
        self.optionSelectType = .comment
        AppDelegate.tabBarController.present(OptionsViewController(delegate: self), animated: true, completion: nil)
    }

    func commentOptions(_ commentOptions: CommentOptionsNode, didPressReplyButtonWithSender sender: ASDisplayNode) {

    }

    func commentOptions(_ commentOptions: CommentOptionsNode, didPressVoteButtonWithSender sender: ASDisplayNode) {
        if self.authenticated() {
            let item = commentOptions.item
            let up = !ItemProvider.didVote(item: item)
            up ? ItemProvider.vote(item: item) : ItemProvider.removeVote(item: item)

            commentOptions.set(upvoted: up)

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

// MARK: - StoryBarDelegate

extension CommentsViewController: StoryBarDelegate {

    func storyBar(_ storyBar: StoryBarNode, didPressShareButtonWithSender sender: ASDisplayNode) {
        if let item = ItemProvider.item(withId: storyBar.itemId) {
            ShareHelper.share(items: item.shareContent(), fromViewController: self, sourceView: sender.view)
        }
    }

    func storyBar(_ storyBar: StoryBarNode, didPressCommentsButtonWithSender sender: ASDisplayNode) {
        if self.comments.count > 0 {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: true)
        }
    }

    func storyBar(_ storyBar: StoryBarNode, didPressVoteButtonWithSender sender: ASDisplayNode) {
        if self.authenticated() {
            if let item = ItemProvider.item(withId: storyBar.itemId) {
                let up = !ItemProvider.didVote(item: self.item)
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

// MARK: - StoryDetailNodeDelegate

extension CommentsViewController: StoryDetailNodeDelegate {

    func storyDetail(_ storyDetail: StoryDetailNode, didPressPosterButtonWithSender sender: ASDisplayNode) {
        self.navController.push(viewController: UserViewController(withUser: self.item.by))
    }

    func storyDetail(_ storyDetail: StoryDetailNode, didPressSiteButtonWithSender sender: ASDisplayNode) {
        if !self.item.url.isEmpty {
            if !self.navController.pop(toViewControllerOfType: WebViewController.classForCoder()) {
                self.navController.push(viewController: WebViewController(item: self.item))
            }
        }
    }

    func storyDetail(_ storyDetail: StoryDetailNode, didPressTitleWithSender sender: ASDisplayNode) {
        if !self.item.url.isEmpty {
            if !self.navController.pop(toViewControllerOfType: WebViewController.classForCoder()) {
                self.navController.push(viewController: WebViewController(item: self.item))
            }
        }
    }

    func storyDetail(_ storyDetail: StoryDetailNode, didPressLink link: String, withSender sender: ASDisplayNode) {
        self.navController.push(viewController: WebViewController(link: link))
    }

}

// MARK: - OptionSelectViewDelegate

/**
 * There are 2 sections
 * Cancel
 * Comments options
 */
enum CommentsSectionType: Int {
    case options = 0
    case cancel = 1

    static var count: Int {
        return 2
    }
}

extension CommentsViewController: OptionSelectViewDelegate {

    func numberOfSections(in optionSelectView: OptionsViewController) -> Int {
        return CommentsSectionType.count
    }

    func optionSelectView(optionSelectView: OptionsViewController, numberOfItemsInSection section: Int) -> Int {

        guard let sectionType = CommentsSectionType(rawValue: section) else {
            assertionFailure("Comments section \(section) not found.")
            return -1
        }

        // check section
        switch sectionType {

        // cancel
        case .cancel:
            return 1

        // options
        case .options:

            // check if this is the general comments screen options or a
            // single comment options
            if let optionSelectType = self.optionSelectType {
                switch optionSelectType {

                // general comments screen options
                case .navigationRight:
                    return CommentsOptionsNavigationRight.values.count

                // single comment options
                case .comment:
                    return CommentsOptionsComment.values.count
                    
                }
            }
        }

        return 0
    }

    func optionSelectView(optionSelectView: OptionsViewController, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {

            guard let sectionType = CommentsSectionType(rawValue: indexPath.section) else {
                assertionFailure("Comments section \(indexPath.section) not found.")
                return ASCellNode()
            }

            // check section
            switch sectionType {

            // cancel
            case .cancel:
                return HNOptionActionNode(optionType: GeneralType.cancel)

            // options
            case .options:

                // check if this is the general comments screen options
                // or just a single comment options
                if let optionSelectType = self.optionSelectType {
                    switch optionSelectType {

                    // general comments screen
                    case .navigationRight:
                        return OptionSelectNode(
                            optionType: CommentsOptionsNavigationRight.values[indexPath.row],
                            selected: false
                        )

                    // single comment
                    case .comment:
                        return OptionSelectNode(
                            optionType: CommentsOptionsComment.values[indexPath.row],
                            selected: false
                        )

                    }
                }
            }

            return ASCellNode()
        }
    }

    func optionSelectView(optionSelectView: OptionsViewController, didSelectItemAtIndexPath indexPath: IndexPath) {

        guard let sectionType = CommentsSectionType(rawValue: indexPath.section) else {
            assertionFailure("Comments section \(indexPath.section) not found.")
            return;
        }

        // check section
        switch sectionType {

        // cancel
        case .cancel:
            return;

        // options
        case .options:

            // check if this is the general comments screen options
            // or just a single comment
            if let optionSelectType = self.optionSelectType {
                switch optionSelectType {

                // general screen options
                case .navigationRight:

                    let option = CommentsOptionsNavigationRight.values[indexPath.row]

                    switch option {
                    case .openInBrowser:
                        Utils.openURL(urlString: self.item.itemWebURL)
                    }

                // just a single comment
                case .comment:

                    if let item = self.optionSelectItem {
                        let option = CommentsOptionsComment.values[indexPath.row]

                        switch option {
                        case .share:
                            ShareHelper.share(items: item.shareContent(), fromViewController: self, sourceView: self.view)

                        case .copy:
                            Utils.copy(string: item.text)
                            
                        case .openInBrowser:
                            Utils.openURL(urlString: item.itemWebURL)
                            
                        }
                    }
                }
            }
        }
    }

}
