//
//  ProfileViewController.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/12/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ProfileViewController: BaseViewController {

    // MARK: - IBOutlets

    var tableView = HNTableNode()
    var authRequiredNode: AuthRequiredNode!

    var refreshControl = UIRefreshControl()

    // MARK: - Properties

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.authRequiredNode.isHidden = User.sharedInstance.isLoggedIn()
        self.setupUser()
        self.setupTabBar()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Setup Helpers

    func setup() {
        self.setupTableView()
        self.setupAuthRequiredNode()
        self.setupNotificationListener()
        self.setupNavigationItem()
        self.setupUser()

        self.refresh()
    }

    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.refreshControl.addTarget(self, action: #selector(self.refresh(refreshControl:)), for: .valueChanged)
        self.tableView.view.addSubview(self.refreshControl)
    }

    func setupAuthRequiredNode() {
        self.authRequiredNode = AuthRequiredNode()
        self.authRequiredNode.frame = self.view.bounds
        self.authRequiredNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.authRequiredNode.delegate = self
        self.view.addSubnode(self.authRequiredNode)
    }

    func setupUser() {
        self.title = User.sharedInstance.id
    }

    func setupNotificationListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh(refreshControl:)), name: Constants.kLoginNotification.name, object: nil)
    }

    func setupNavigationItem() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    func setupTabBar() {
        self.navController.tabBarItem.title = nil
    }

    // MARK: - Helpers

    func refresh(refreshControl: UIRefreshControl? = nil) {
        DispatchQueue.default.async {
            if !User.sharedInstance.id.isEmpty {
                HNAPI.user(id: User.sharedInstance.id)
                    .then { result -> Void in
                        // save the item
                        User.sharedInstance = result
                        ItemProvider.set(currentUser: result)

                        self.setupUser()

                        self.tableView.reloadData()

                    }.always {
                        self.refreshControl.endRefreshing()
                    }.catch { error in
                        print(error) // TODO: - Handle this
                }
            }
        }
    }

}

// MARK: - ASTableDataSource, ASTableDelegate

extension ProfileViewController: ASTableDataSource, ASTableDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return User.sharedInstance.about.isEmpty ? 1 : 2
        default:
            return ProfileOptionsType.values.count
        }
    }

    func tableView(_ tableView: ASTableView, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            switch indexPath.section {
            case 0:

                switch indexPath.row {
                case 0:
                    return UserAboutNode(withUser: User.sharedInstance)
                default:
                    return UserAboutBioNode(withUser: User.sharedInstance)
                }

            default:

                let option = ProfileOptionsType.values[indexPath.row]

                switch option {
                case .history:
                    return SettingsNode(openNodeWithType: option)
                case .posts:
                    return SettingsNode(openNodeWithType: option)
                case .comments:
                    return SettingsNode(openNodeWithType: option)
                case .logout:
                    return SettingsNode(actionNodeWithType: option)
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break
        default:

            let option = ProfileOptionsType.values[indexPath.row]

            switch option {
            case .history:
                self.navController.push(viewController: HistoryViewController())
            case .posts:
                let vc = UserPostsViewController(withUser: User.sharedInstance.id)
                vc.title = option.title
                self.navController.push(viewController: vc)
            case .comments:
                let vc = UserCommentsViewController(withUser: User.sharedInstance.id)
                vc.title = option.title
                self.navController.push(viewController: vc)
            case .logout:
                AlertBuilder()
                    .set(message: "kConfirmLogout".localized)
                    .add(actionWithTitle: "kYes".localized, style: .default, handler: { _ in
                        User.sharedInstance.logout()

                        self.authRequiredNode.isHidden = User.sharedInstance.isLoggedIn()
                        self.setupUser()
                    })
                    .add(actionWithTitle: "kNo".localized, style: .cancel, handler: nil)
                    .present(sender: self)
            }

        }

        self.tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension ProfileViewController: AuthRequiredNodeDelegate {

    func authRequiredNode(didPressLoginButton button: ASDisplayNode) {
        self.present(AuthViewController(state: .login), animated: true, completion: nil)
    }

    func authRequiredNode(didPressSignupButton button: ASDisplayNode) {
        self.present(AuthViewController(state: .register), animated: true, completion: nil)
    }

}
