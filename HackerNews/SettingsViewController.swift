//
//  SettingsViewController.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/30/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class SettingsViewController: BaseViewController {

    // MARK: - IBOutlets

    var tableView = SettingsTableView()

    // MARK: - Properties

    var optionSelectType: SettingsType = .none

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

        self.setupTabBar()
    }

    // MARK: - Setup Helpers

    func setup() {
        self.title = "Settings"
        self.setupTableView()
    }

    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    func setupTabBar() {
        self.navController.tabBarItem.title = nil
    }

}

// MARK: - ASTableDataSource, ASTableDelegate

extension SettingsViewController: ASTableDataSource, ASTableDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsType.values.count
    }

    func tableView(_ tableView: ASTableView, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            let settingsType = SettingsType.values[indexPath.row]

            switch settingsType {
            case .defaultStoryType:
                return SettingsNode(dropdownNodeWithType: settingsType, selected: SettingsProvider.storyType)

            case .font:
                return SettingsNode(dropdownNodeWithType: settingsType, selected: SettingsProvider.font)

            case .fontSize:
                return SettingsNode(dropdownNodeWithType: settingsType, selected: SettingsProvider.fontSize)

            case .theme:
                return SettingsNode(dropdownNodeWithType: settingsType, selected: SettingsProvider.theme)

            case .clearCache:
                return SettingsNode(actionNodeWithType: settingsType)

            default:
                return SettingsNode(actionNodeWithType: settingsType)
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.optionSelectType = SettingsType.values[indexPath.row]

        AppDelegate.tabBarController.present(OptionsViewController(delegate: self), animated: true, completion: nil)

        self.tableView.deselectRow(at: indexPath, animated: true)
    }

}

// MARK: - OptionSelectViewDelegate

/**
 * There are 2 sections.
 * Cancel
 * Options
 */
enum SettingsSectionType: Int {
    case options = 0
    case cancel = 1

    static var count: Int {
        return 2
    }
}

extension SettingsViewController: OptionSelectViewDelegate {

    func numberOfSections(in optionSelectView: OptionsViewController) -> Int {
        return SettingsSectionType.count
    }

    func optionSelectView(optionSelectView: OptionsViewController, numberOfItemsInSection section: Int) -> Int {

        guard let sectionType = SettingsSectionType(rawValue: section) else {
            assertionFailure("Settings section \(section) not found.")
            return -1
        }

        // check section
        switch sectionType {

        // cancel
        case .cancel:
            return 1

        // options
        case .options:

            switch self.optionSelectType {
            case .defaultStoryType:
                return StoryType.values.count

            case .font:
                return FontType.values.count

            case .fontSize:
                return FontSizeType.values.count

            case .theme:
                return ThemeType.values.count

            case .clearCache:
                return 1
                
            default:
                return 0
            }

        }

    }

    func optionType(optionTypeForItemAtIndexPath indexPath: IndexPath) -> OptionType {
        switch self.optionSelectType {
        case .defaultStoryType:
            return StoryType.values[indexPath.row]

        case .font:
            return FontType.values[indexPath.row]

        case .fontSize:
            return FontSizeType.values[indexPath.row]

        case .theme:
            return ThemeType.values[indexPath.row]

        case .clearCache:
            return SettingsType.clearCache

        default:
            return GeneralType.none
        }
    }

    func optionSelected(isOptionSelectedForItemAtIndexPath indexPath: IndexPath) -> Bool {
        switch self.optionSelectType {
        case .defaultStoryType:
            return StoryType.values[indexPath.row] == SettingsProvider.storyType

        case .font:
            return FontType.values[indexPath.row] == SettingsProvider.font

        case .fontSize:
            return FontSizeType.values[indexPath.row] == SettingsProvider.fontSize

        case .theme:
            return ThemeType.values[indexPath.row] == SettingsProvider.theme

        default:
            return false
        }
    }

    func optionSelectView(optionSelectView: OptionsViewController, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {

            guard let sectionType = SettingsSectionType(rawValue: indexPath.section) else {
                assertionFailure("Settings section \(indexPath.section) not found.")
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
                    optionType: self.optionType(optionTypeForItemAtIndexPath: indexPath),
                    selected: self.optionSelected(isOptionSelectedForItemAtIndexPath: indexPath)
                )

            }
        }
    }

    func optionSelectView(optionSelectView: OptionsViewController, didSelectItemAtIndexPath indexPath: IndexPath) {

        guard let sectionType = SettingsSectionType(rawValue: indexPath.section) else {
            assertionFailure("Settings section \(indexPath.section) not found.")
            return;
        }

        // check section
        switch sectionType {

        // cancel
        case .cancel:
            return;

        // options
        case .options:

            switch self.optionSelectType {
            case .defaultStoryType:
                SettingsProvider.storyType = StoryType.values[indexPath.row]

            case .font:
                SettingsProvider.font = FontType.values[indexPath.row]

                let delegate = (UIApplication.shared.delegate as! AppDelegate)
                delegate.setupTabBarController()
                delegate.setupWindow()

            case .fontSize:
                SettingsProvider.fontSize = FontSizeType.values[indexPath.row]

                let delegate = (UIApplication.shared.delegate as! AppDelegate)
                delegate.setupTabBarController()
                delegate.setupWindow()

            case .theme:
                SettingsProvider.theme = ThemeType.values[indexPath.row]

                let delegate = (UIApplication.shared.delegate as! AppDelegate)
                delegate.setupTabBarController()
                delegate.setupWindow()

            case .clearCache:
                ItemProvider.clear(toDate: Date())
                User.sharedInstance.logout()

            default:
                break
            }

        }
    }

}
