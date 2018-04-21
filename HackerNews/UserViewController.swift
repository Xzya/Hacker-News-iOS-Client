//
//  UserViewController.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/5/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import AsyncDisplayKit

class UserViewController: HNPagerViewController {

    // MARK: - Properties

    var user: String = ""

    // MARK: - Lifecycle

    init(withUser user: String) {
        self.user = user

        super.init(nibName: nil, bundle: nil)
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
        self.title = user

        self.setupNavigationItem()
        self.setupTheme()
    }

    func setupNavigationItem() {
        self.navigationItem.set(rightButtonIcon: .ion_more, target: self, action: #selector(self.onNavigationRightButtonPressed))
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    // MARK: - IBActions

    func onNavigationRightButtonPressed() {
        AppDelegate.tabBarController.present(OptionsViewController(delegate: self), animated: true, completion: nil)
    }

    // MARK: - PagerTabStripDataSource

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return [
            UserAboutViewController(withUser: self.user),
            UserPostsViewController(withUser: self.user),
            UserCommentsViewController(withUser: self.user)
        ]
    }

}

// MARK: - OptionSelectViewDelegate

/**
 * There are 2 sections.
 * Cancel
 * Options
 */
enum UserSectionType: Int {
    case options = 0
    case cancel = 1

    static var count: Int {
        return 2
    }
}

extension UserViewController: OptionSelectViewDelegate {

    func numberOfSections(in optionSelectView: OptionsViewController) -> Int {
        return UserSectionType.count
    }

    func optionSelectView(optionSelectView: OptionsViewController, numberOfItemsInSection section: Int) -> Int {

        guard let sectionType = UserSectionType(rawValue: section) else {
            assertionFailure("User section \(section) not found.")
            return -1
        }

        // check section
        switch sectionType {

        // cancel
        case .cancel:
            return 1

        // options
        case .options:
            return UserOptionsNavigationRight.values.count
        }

    }

    func optionSelectView(optionSelectView: OptionsViewController, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {

            guard let sectionType = UserSectionType(rawValue: indexPath.section) else {
                assertionFailure("User section \(indexPath.section) not found.")
                return ASCellNode()
            }

            // check section
            switch sectionType {

            // cancel
            case .cancel:
                return HNOptionActionNode(optionType: GeneralType.cancel)

            // options
            case .options:
                return OptionSelectNode(
                    optionType: UserOptionsNavigationRight.values[indexPath.row],
                    selected: false
                )
                
            }
        }
    }

    func optionSelectView(optionSelectView: OptionsViewController, didSelectItemAtIndexPath indexPath: IndexPath) {

        guard let sectionType = UserSectionType(rawValue: indexPath.section) else {
            assertionFailure("User section \(indexPath.section) not found.")
            return;
        }

        // check section
        switch sectionType {

        // cancel
        case .cancel:
            return;

        // options
        case .options:

            let option = UserOptionsNavigationRight.values[indexPath.row]

            switch option {
            case .openInBrowser:
                Utils.openURL(urlString: User.userWebURL(user: self.user))

            }
        }
    }

}
