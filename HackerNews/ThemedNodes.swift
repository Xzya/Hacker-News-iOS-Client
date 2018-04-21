//
//  ThemedNodes.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 6/2/17.
//  Copyright © 2017 Null. All rights reserved.
//

import UIKit

// MARK: - StoryNode

extension StoryNode: HNThemable {
    func setupTheme() {
        self.backgroundColor = Styles.story.background
    }
}

// MARK: - StoryBarNode

extension StoryBarNode: HNThemable {
    func setupTheme() {
        self.backgroundColor = Styles.storyBar.background
        self.leftDividerNode.backgroundColor = Styles.storyBar.divider
        self.rightDividerNode.backgroundColor = Styles.storyBar.divider
    }
}

// MARK: - StoryDetail Node

extension StoryDetailNode: HNThemable {
    func setupTheme() {
        self.selectionStyle = .none
        self.backgroundColor = ThemeManager.current.primary
        self.dividerNode.backgroundColor = ThemeManager.current.divider
    }
}

// MARK: - StoryTypeNode

extension StoryTypeNode: HNThemable {
    func setupTheme() {
        self.backgroundColor = Styles.storyType.background
    }
}

// MARK: - CommentNode

extension CommentNode: HNThemable {
    func setupTheme() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.containerNode.backgroundColor = ThemeManager.current.primaryBackground
    }
}

// MARK: - CommentOptionsNode

extension CommentOptionsNode: HNThemable {
    func setupTheme() {
        self.selectionStyle = .none
        self.backgroundColor = ThemeManager.current.primaryBackground
        self.topDividerNode.backgroundColor = ThemeManager.current.divider
        self.bottomDividerNode.backgroundColor = ThemeManager.current.divider
    }
}

// MARK: - BackgroundDividerNode

extension BackgroundDividerNode: HNThemable {
    func setupTheme() {
        for i in 0..<self.dividers.count {
            self.dividers[i].backgroundColor = ThemeManager.current.primaryBackground
        }
    }
}

// MARK: - AuthNode

extension AuthNode: HNThemable {
    func setupTheme() {
        self.backgroundColor = ThemeManager.current.primaryBackground
        self.navigationBar.backgroundColor = ThemeManager.current.primary
    }
}

// MARK: - AuthRequiredNode

extension AuthRequiredNode: HNThemable {
    func setupTheme() {
        self.backgroundColor = ThemeManager.current.primaryBackground
    }
}

// MARK: - HNTableNode

extension HNTableNode: HNThemable {
    func setupTheme() {
        self.backgroundColor = UIColor.clear
        self.view.separatorColor = ThemeManager.current.primaryBackground
    }
}

// MARK: - SettingsNode

extension SettingsNode: HNThemable {
    func setupTheme() {
        self.backgroundColor = ThemeManager.current.secondaryBackground
    }
}

// MARK: - SettingsTableView

extension SettingsTableView {
    override func setupTheme() {
        self.backgroundColor = ThemeManager.current.secondaryBackground
        self.view.separatorColor = ThemeManager.current.primaryBackground
    }
}

// MARK: - UserCommentNode

extension UserCommentNode: HNThemable {
    func setupTheme() {
        self.backgroundColor = ThemeManager.current.secondaryBackground
    }
}

// MARK: - UserAboutNode

extension UserAboutNode: HNThemable {
    func setupTheme() {
        self.backgroundColor = ThemeManager.current.secondaryBackground
    }
}

// MARK: - UserAboutBioNode

extension UserAboutBioNode: HNThemable {
    func setupTheme() {
        self.backgroundColor = ThemeManager.current.secondaryBackground
    }
}

// MARK: - TextFieldNode

extension TextFieldNode: HNThemable {
    func setupTheme() {
        self.backgroundColor = UIColor.clear
        self.typingAttributes = Styles.textField.text
        self.keyboardAppearance = ThemeManager.current.contentMode == .light ? .dark : .light
    }
}

// MARK: - FullButtonNode

extension FullButtonNode: HNThemable {
    func setupTheme() {
        self.contentHorizontalAlignment = .middle
        self.backgroundColor = ThemeManager.current.secondary
    }
}

// MARK: - OptionSelectTableView

extension OptionSelectTableView: HNThemable {
    func setupTheme() {
        self.view.separatorColor = ThemeManager.current.primaryBackground
        self.backgroundColor = UIColor.clear
    }
}

// MARK: - OptionSelectNode

extension OptionSelectNode: HNThemable {
    func setupTheme() {
        self.backgroundColor = Styles.options.background
    }
}

// MARK: - HNOptionActionNode

extension HNOptionActionNode: HNThemable {
    func setupTheme() {
        self.backgroundColor = Styles.options.backgroundLight
    }
}

// MARK: - HNOptionHeaderNode

extension HNOptionHeaderNode: HNThemable {
    func setupTheme() {
        self.backgroundColor = Styles.options.background
        self.topDividerNode.backgroundColor = ThemeManager.current.primaryBackground
        self.bottomDividerNode.backgroundColor = UIColor.clear
    }
}

// MARK: - MiddleButtonNode

extension MiddleButtonNode: HNThemable {
    func setupTheme() {
        self.contentHorizontalAlignment = .middle
    }
}

// MARK: - HNPostStoryNode

extension HNPostStoryNode: HNThemable {
    func setupTheme() {
        self.backgroundColor = ThemeManager.current.primaryBackground
        self.navigationBar.backgroundColor = ThemeManager.current.primary
    }
}

// MARK: - BaseViewController

extension BaseViewController: HNThemable {
    func setupTheme() {
        self.view.backgroundColor = Styles.base.background
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return ThemeManager.current.contentMode == .light ? .lightContent : .default
    }
}

// MARK: TabBarController

extension TabBarController: HNThemable {
    func setupTheme() {
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = ThemeManager.current.primary
        self.tabBar.set(topBorderColor: ThemeManager.current.primaryBackground, height: 1)
    }
}

// MARK: - OptionsViewController

extension OptionsViewController {
    override func setupTheme() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
}

// MARK: - AuthViewController

extension AuthViewController {
    override func setupTheme() {
        self.view.backgroundColor = ThemeManager.current.primaryBackground
    }
}

// MARK: - WebViewController

extension WebViewController {
    override func setupTheme() {
        self.view.backgroundColor = ThemeManager.current.primary
    }
}

// MARK: - NavigationController

extension NavigationController: HNThemable {
    func setupTheme() {
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = ThemeManager.current.primary
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: ThemeManager.current.secondaryText]
        self.navigationBar.set(bottomBorderColor: ThemeManager.current.primaryBackground, height: 1)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return ThemeManager.current.contentMode == .light ? .lightContent : .default
    }
}

// MARK: - CommentsTableView

extension CommentsTableView: HNThemable {
    func setupTheme() {
        self.backgroundColor = ThemeManager.current.primaryBackground
        self.view.backgroundColor = ThemeManager.current.primaryBackground
    }
}

// MARK: - UserViewController

extension UserViewController: HNThemable {
    func setupTheme() {
        self.view.backgroundColor = ThemeManager.current.primaryBackground
    }
}

// MARK: - SearchViewController

extension SearchViewController: HNThemable {
    func setupTheme() {
        self.view.backgroundColor = ThemeManager.current.primaryBackground

        self.searchBar.barTintColor = ThemeManager.current.secondaryBackground
        self.searchBar.isTranslucent = false
        self.searchBar.keyboardAppearance = ThemeManager.current.contentMode == .light ? .dark : .light
        self.searchBar.showsBookmarkButton = true
        self.searchBar.setImage(
            IonIcon.image(iconType: .ion_ios_settings_strong, color: ThemeManager.current.secondaryText),
            for: .bookmark,
            state: .normal
        )

        for view in self.searchBar.subviews {
            for subview in view.subviews {
                if let textField = subview as? UITextField {
                    textField.backgroundColor = ThemeManager.current.secondaryBackground
                    textField.textColor = ThemeManager.current.secondaryText
                }

                if subview.isKind(of: NSClassFromString("UISearchBarBackground")!) {
                    subview.alpha = 0
                }
            }
        }
    }
}
