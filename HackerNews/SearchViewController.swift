//
//  SearchViewController.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/6/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import AsyncDisplayKit

class SearchViewController: HNPagerViewController {

    // MARK: - IBOutlets

    var searchBar: UISearchBar!

    var timeHeaderNode = HNOptionHeaderNode(withTitle: SearchTimeRangeType.label)
    var sortHeaderNode = HNOptionHeaderNode(withTitle: SearchSortType.label)

    // MARK: - Properties

    var sortType: SearchSortType = .relevance
    var timeRangeType: SearchTimeRangeType = .all

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }

    // MARK: - Setup Helpers

    func setup() {
        self.setupSearchBar()
        self.setupTabBar()
        self.setupNavigationItem()
        self.setupTheme()
    }

    func setupSearchBar() {
        self.searchBar = UISearchBar()
        self.searchBar.delegate = self

        self.navigationItem.titleView = self.searchBar
    }

    func setupNavigationItem() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    func setupTabBar() {
        self.navigationController?.tabBarItem.title = nil
    }

    // MARK: - Helpers

    func search(withQuery query: String) {
        var notification = Constants.kSearchNotification
        notification.userInfo = [
            "query": query,
            "sort": self.sortType,
            "timeRange": self.timeRangeType
        ]
        NotificationCenter.default.post(notification)
    }

    // MARK: - PagerTabStripDataSource

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return [
            SearchStoriesViewController(),
            SearchCommentsViewController()
        ]
    }

}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        if let query = searchBar.text {
            self.search(withQuery: query)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        AppDelegate.tabBarController.present(OptionsViewController(delegate: self), animated: true, completion: nil)
    }

}

// MARK: - OptionSelectViewDelegate

/**
 * There are 3 sections.
 * Close
 * Time range
 * Sort
 */
enum SearchSectionType: Int {
    case sort = 0
    case timeRange = 1
    case close = 2

    static var count: Int {
        return 3
    }
}

extension SearchViewController: OptionSelectViewDelegate {

    func numberOfSections(in optionSelectView: OptionsViewController) -> Int {
        return SearchSectionType.count
    }

    func optionSelectView(optionSelectView: OptionsViewController, numberOfItemsInSection section: Int) -> Int {

        guard let sectionType = SearchSectionType(rawValue: section) else {
            assertionFailure("Search section \(section) not found.")
            return -1
        }

        // check section
        switch sectionType {

        // close
        case .close:
            return 1

        // time range
        case .timeRange:
            return SearchTimeRangeType.values.count

        // sort type
        case .sort:
            return SearchSortType.values.count
        }

    }

    func optionSelectView(optionSelectView: OptionsViewController, viewForHeaderInSection section: Int) -> UIView? {

        guard let sectionType = SearchSectionType(rawValue: section) else {
            assertionFailure("Search section \(section) not found.")
            return nil
        }

        // check section
        switch sectionType {

        // close
        case .close:
            return nil

        // time range
        case .timeRange:
            return self.timeHeaderNode.view

        // sort type
        case .sort:
            return self.sortHeaderNode.view
        }

    }

    func optionSelectView(optionSelectView: OptionsViewController, heightForHeaderInSection section: Int) -> CGFloat {

        guard let sectionType = SearchSectionType(rawValue: section) else {
            assertionFailure("Search section \(section) not found.")
            return 0
        }

        // check section
        switch sectionType {

        // close
        case .close:
            return 0

        // time range
        case .timeRange:
            return self.timeHeaderNode.layoutThatFits(size: optionSelectView.view.frame.size).size.height

        // sort type
        case .sort:
            return self.sortHeaderNode.layoutThatFits(size: optionSelectView.view.frame.size).size.height
        }

    }

    func optionSelectView(optionSelectView: OptionsViewController, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {

            guard let sectionType = SearchSectionType(rawValue: indexPath.section) else {
                assertionFailure("Search section \(indexPath.section) not found.")
                return ASCellNode()
            }

            // check section
            switch sectionType {

            // close
            case .close:
                return HNOptionActionNode(optionType: GeneralType.close)

            // time range
            case .timeRange:
                return OptionSelectNode(
                    optionType: SearchTimeRangeType.values[indexPath.row],
                    selected: SearchTimeRangeType.values[indexPath.row] == self.timeRangeType
                )

            // sort type
            case .sort:
                return OptionSelectNode(
                    optionType: SearchSortType.values[indexPath.row],
                    selected: SearchSortType.values[indexPath.row] == self.sortType
                )
            }

        }
    }

    func optionSelectView(optionSelectView: OptionsViewController, didSelectItemAtIndexPath indexPath: IndexPath) {

        guard let sectionType = SearchSectionType(rawValue: indexPath.section) else {
            assertionFailure("Search section \(indexPath.section) not found.")
            return;
        }

        // check section
        switch sectionType {

        // close
        case .close:
            return;

        // time range
        case .timeRange:

            // if we didn't select the same type
            if SearchTimeRangeType.values[indexPath.row] != self.timeRangeType {

                // save the type
                self.timeRangeType = SearchTimeRangeType.values[indexPath.row]

                // make the search again
                if let query = self.searchBar.text {
                    self.search(withQuery: query)
                }

            }

        // sort type
        case .sort:

            // if we didn't select the same type
            if SearchSortType.values[indexPath.row] != self.sortType {

                // save the type
                self.sortType = SearchSortType.values[indexPath.row]

                // make the search again
                if let query = self.searchBar.text {
                    self.search(withQuery: query)
                }

            }
        }
    }
    
}
