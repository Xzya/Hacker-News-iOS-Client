//
//  ThemeManager.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/9/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit

/**
 * Content mode.
 */
enum ContentMode {
    case light
    case dark
}

/**
 * Themable protocol.
 */
protocol HNThemable {
    func setupTheme()
}

/**
 * Contains the text colors.
 */
open class Color {
    // dark text
    open class darkText {
        open static let primary = UIColor.black.withAlphaComponent(0.87)
        open static let secondary = UIColor.black.withAlphaComponent(0.54)
        open static let others = UIColor.black.withAlphaComponent(0.38)
        open static let dividers = UIColor.black.withAlphaComponent(0.12)
    }

    // light text
    open class lightText {
        open static let primary = UIColor.white
        open static let secondary = UIColor.white.withAlphaComponent(0.7)
        open static let others = UIColor.white.withAlphaComponent(0.5)
        open static let dividers = UIColor.white.withAlphaComponent(0.12)
    }
}

/**
 * Theme
 */
struct HNTheme {

    /**
     * The primary color.
     */
    var primary: UIColor

    /**
     * The secondary color. This will be used for highlighted elements.
     */
    var secondary: UIColor

    /**
     * The primary background color.
     */
    var primaryBackground: UIColor

    /**
     * The secondary background color.
     */
    var secondaryBackground: UIColor

    /**
     * Primary text color. Used for primary elements, like titles.
     */
    var primaryText: UIColor

    /**
     * Secondary text color. Used for secondary elements, like subtitles.
     */
    var secondaryText: UIColor

    /**
     * Color for other elements. Used for stuff like disabled elements and already seen titles.
     */
    var other: UIColor

    /**
     * Dividers color.
     */
    var divider: UIColor

    /**
     * The content mode of the theme (light/dark).
     */
    var contentMode: ContentMode

    init(primary: UIColor, secondary: UIColor, primaryBackground: UIColor, secondaryBackground: UIColor, contentMode: ContentMode) {

        // content mode
        self.contentMode = contentMode

        // primary
        self.primary = primary

        // secondary
        self.secondary = secondary

        // background
        self.primaryBackground = primaryBackground
        self.secondaryBackground = secondaryBackground

        // text
        self.primaryText = contentMode == .light ? Color.lightText.primary : Color.darkText.primary
        self.secondaryText = contentMode == .light ? Color.lightText.secondary : Color.darkText.secondary

        // others
        self.other = contentMode == .light ? Color.lightText.others : Color.darkText.others

        // dividers
        self.divider = contentMode == .light ? Color.lightText.dividers : Color.darkText.dividers
    }

    static let dark: HNTheme = {
        return HNTheme(primary: #colorLiteral(red: 0.06274509804, green: 0.06274509804, blue: 0.06274509804, alpha: 1), secondary: #colorLiteral(red: 1, green: 0.4, blue: 0, alpha: 1), primaryBackground: #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1), secondaryBackground: #colorLiteral(red: 0.1129432991, green: 0.1129470244, blue: 0.1129450426, alpha: 1), contentMode: .light)
    }()
    static let light: HNTheme = {
        return HNTheme(primary: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), secondary: #colorLiteral(red: 0.09004751593, green: 0.4740691781, blue: 0.825284183, alpha: 1), primaryBackground: #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.9607843137, alpha: 1), secondaryBackground: #colorLiteral(red: 0.9882352941, green: 0.9882352941, blue: 0.9843137255, alpha: 1), contentMode: .dark)
    }()
    static let blue: HNTheme = {
        return HNTheme(primary: #colorLiteral(red: 0.8823529412, green: 0.9607843137, blue: 0.9960784314, alpha: 1), secondary: #colorLiteral(red: 1, green: 0.4, blue: 0, alpha: 1), primaryBackground: #colorLiteral(red: 0.7843137255, green: 0.862745098, blue: 0.8980392157, alpha: 1), secondaryBackground: #colorLiteral(red: 0.831372549, green: 0.9098039216, blue: 0.9450980392, alpha: 1), contentMode: .dark)
    }()
    static let orange: HNTheme = {
        return HNTheme(primary: #colorLiteral(red: 0.9019607843, green: 0.3176470588, blue: 0, alpha: 1), secondary: #colorLiteral(red: 0.06274509804, green: 0.06274509804, blue: 0.06274509804, alpha: 1), primaryBackground: #colorLiteral(red: 0.9607843137, green: 0.4862745098, blue: 0, alpha: 1), secondaryBackground: #colorLiteral(red: 0.937254902, green: 0.4235294118, blue: 0, alpha: 1), contentMode: .light)
    }()

}

/**
 * ThemeManager handles the themes.
 */
class ThemeManager {

    /**
     * The current theme.
     */
    static var current: HNTheme = {
        return ThemeManager.get(ofType: SettingsProvider.theme)
    }()

    /**
     * Sets the given theme.
     */
    static func set(theme: HNTheme) {
        self.current = theme

        // general settings
        UITableView.appearance().backgroundColor = theme.primary
        UITableViewCell.appearance().backgroundColor = theme.primary
        UIButton.appearance().tintColor = theme.other
        UINavigationBar.appearance().tintColor = theme.other
        UIApplication.shared.keyWindow?.tintColor = theme.other
        UIApplication.shared.keyWindow?.backgroundColor = theme.primary
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: theme.secondary], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: theme.primaryBackground], for: .normal)
        UITabBar.appearance().tintColor = ThemeManager.current.secondary
        UIApplication.shared.setStatusBarStyle(theme.contentMode == .light ? .lightContent : .default, animated: true)
    }

    /**
     * Returns the theme for a given ThemeType.
     */
    static func get(ofType type: ThemeType) -> HNTheme {
        switch type {
        case .dark:
            return .dark
        case .light:
            return .light
        case .blue:
            return .blue
        case .orange:
            return .orange
        }
    }

    /**
     * Sets the given ThemeType.
     */
    static func set(themeType type: ThemeType) {
        self.set(theme: self.get(ofType: type))
    }

}
