//
//  UserAboutViewController.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/6/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import XLPagerTabStrip

class UserAboutViewController: BaseViewController {

    // MARK: - IBOutlets

    var tableView = HNTableNode()

    // MARK: - Properties

    var refreshControl: UIRefreshControl = UIRefreshControl()

    var userId: String = ""
    var user: User = User()

    // MARK: - Lifecycle

    init(withUser user: String) {
        self.userId = user

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
        self.user = ItemProvider.user(withId: self.userId) ?? self.user

        self.setupTableView()
        self.refresh()
    }

    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.refreshControl.addTarget(self, action: #selector(self.refresh(refreshControl:)), for: .valueChanged)
        self.tableView.view.addSubview(self.refreshControl)
    }

    // MARK: - Helpers

    func refresh(refreshControl: UIRefreshControl? = nil) {
        DispatchQueue.default.async {
            HNAPI.user(id: self.userId)
                .then { result -> Void in
                    // save the item
                    self.user = result
                    let _ = ItemProvider.add(user: self.user)

                    self.tableView.reloadData()

                }.always {
                    self.refreshControl.endRefreshing()
                }.catch { error in
                    print(error) // TODO: - Handle this
            }
        }
    }

}

// MARK: - IndicatorInfoProvider

extension UserAboutViewController: IndicatorInfoProvider {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "About")
    }

}

// MARK: - ASTableDataSource, ASTableDelegate

extension UserAboutViewController: ASTableDataSource, ASTableDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.user.about.isEmpty ? 1 : 2
    }

    func tableView(_ tableView: ASTableView, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            switch indexPath.row {
            case 0:
                return UserAboutNode(withUser: self.user)
            default:
                let node = UserAboutBioNode(withUser: self.user)
                node.delegate = self
                return node
            }
        }
    }

    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }

}

// MARK: - UserAboutBioNodeDelegate

extension UserAboutViewController: UserAboutBioNodeDelegate {

    func userAboutBioNode(_ userAboutBioNode: UserAboutBioNode, didPressLink link: String, withSender sender: ASDisplayNode) {
        self.navController.push(viewController: WebViewController(link: link))
    }

}
