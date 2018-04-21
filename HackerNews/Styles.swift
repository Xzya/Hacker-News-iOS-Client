//
//  Styles.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/22/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit

open class Styles {

    // MARK: - BaseViewController

    /**
     * BaseViewController styles.
     */
    open class base {

        /**
         * Background
         */
        open static var background: UIColor {
            return ThemeManager.current.primaryBackground
        }

    }

    // MARK: - Story

    /**
     * StoryNode styles.
     */
    open class story {

        /**
         * Story OP
         */
        open static var poster: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.subtitleFont,
                NSForegroundColorAttributeName: ThemeManager.current.secondaryText
            ]
        }

        /**
         * Story website
         */
        open static var website: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.subtitleFont,
                NSForegroundColorAttributeName: ThemeManager.current.secondaryText
            ]
        }

        /**
         * Story post time
         */
        open static var time: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.subtitleFont,
                NSForegroundColorAttributeName: ThemeManager.current.secondaryText
            ]
        }

        /**
         * Story title
         */
        open static var title: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.textFont,
                NSForegroundColorAttributeName: ThemeManager.current.primaryText
            ]
        }

        /**
         * Story read title
         */
        open static var seenTitle: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.textFont,
                NSForegroundColorAttributeName: ThemeManager.current.other
            ]
        }

        /**
         * Story background
         */
        open static var background: UIColor {
            return ThemeManager.current.primary
        }

    }

    // MARK: - Story details

    /**
     * StoryDetailNode styles.
     */
    open class storyDetails {

        /**
         * Story detail title
         */
        open static var title: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.titleFont,
                NSForegroundColorAttributeName: ThemeManager.current.primaryText
            ]
        }

        /**
         * Story detail text
         */
        open static var text: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.textFont,
                NSForegroundColorAttributeName: ThemeManager.current.secondaryText
            ]
        }

    }

    // MARK: - Story bar

    /**
     * StoryBarNode styles.
     */
    open class storyBar {

        /**
         * Story bar icon
         */
        open static var icon: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.subtitleIconFont,
                NSForegroundColorAttributeName: ThemeManager.current.other
            ]
        }

        /**
         * Story bar highlighted icon
         */
        open static var highlightedIcon: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.subtitleIconFont,
                NSForegroundColorAttributeName: ThemeManager.current.secondary
            ]
        }

        /**
         * Story bar buttons
         */
        open static var button: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.subtitleFont,
                NSForegroundColorAttributeName: ThemeManager.current.other
            ]
        }

        /**
         * Story bar background
         */
        open static var background: UIColor {
            return ThemeManager.current.primary
        }

        /**
         * Story bar dividers
         */
        open static var divider: UIColor {
            return ThemeManager.current.divider
        }

    }

    // MARK: - Story type

    /**
     * StoryTypeNode styles.
     */
    open class storyType {

        /**
         * Title
         */
        open static var title: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.textFont,
                NSForegroundColorAttributeName: ThemeManager.current.other
            ]
        }

        /**
         * Background
         */
        open static var background: UIColor {
            return ThemeManager.current.primaryBackground
        }

    }

    // MARK: - Comments

    /**
     * CommentNode styles.
     */
    open class comment {

        /**
         * Comment text.
         */
        open static var text: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.textFont,
                NSForegroundColorAttributeName: ThemeManager.current.secondaryText
            ]
        }

        /**
         * Comment indentation divider.
         */
        open static var divider: UIColor {
            return ThemeManager.current.divider
        }

    }

    // MARK: - Comment options

    /**
     * CommentOptionsNode styles.
     */
    open class commentOptions {

        /**
         * Comment options icon.
         */
        open static var icon: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.subtitleIconFont,
                NSForegroundColorAttributeName: ThemeManager.current.other
            ]
        }

        /**
         * Highlighted comment options icon.
         */
        open static var highlightedIcon: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.subtitleIconFont,
                NSForegroundColorAttributeName: ThemeManager.current.secondary
            ]
        }

        /**
         * Comment option text.
         */
        open static var text: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.subtitleFont,
                NSForegroundColorAttributeName: ThemeManager.current.other
            ]
        }
        
    }

    // MARK: - Options

    /**
     * Options styles.
     */
    open class options {

        /**
         * Option background.
         */
        open static var background: UIColor {
            return ThemeManager.current.secondaryBackground
        }

        /**
         * Light background.
         */
        open static var backgroundLight: UIColor {
            return ThemeManager.current.primaryBackground
        }

        /**
         * Icon.
         */
        open static var icon: UIColor {
            return ThemeManager.current.other
        }

        /**
         * Highlighed icon.
         */
        open static var highlightedIcon: UIColor {
            return ThemeManager.current.secondary
        }

        /**
         * Option title.
         */
        open static var title: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.textFont,
                NSForegroundColorAttributeName: ThemeManager.current.secondaryText
            ]
        }

        /**
         * Option header.
         */
        open static var header: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.subtitleFont,
                NSForegroundColorAttributeName: ThemeManager.current.secondaryText
            ]
        }

    }

    // MARK: - Settings

    /**
     * Settings styles.
     */
    open class settings {

        /**
         * Settings icons.
         */
        open static var icon: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.textIconFont,
                NSForegroundColorAttributeName: ThemeManager.current.other
            ]
        }

        /**
         * Settings title.
         */
        open static var title: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.textFont,
                NSForegroundColorAttributeName: ThemeManager.current.secondaryText
            ]
        }

        /**
         * Settings selected title.
         */
        open static var selectedTitle: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.textFont,
                NSForegroundColorAttributeName: ThemeManager.current.other
            ]
        }

        /**
         * Settings right icon.
         */
        open static var rightIcon: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.textIconFont,
                NSForegroundColorAttributeName: ThemeManager.current.secondaryText
            ]
        }

    }

    // MARK: - Tabs

    /**
     * TabBarController styles.
     */
    open class tabBar {

        /**
         * Tab icon.
         */
        open static var icon: UIColor {
            return ThemeManager.current.primaryBackground
        }

    }

    // MARK: - Navigation

    /**
     * Node styles.
     */
    open class navigation {

        /**
         * Icon.
         */
        open static var icon: [String: Any] {
            return [
                NSFontAttributeName: UIFont.ionIconFont(ofSize: UIFont.buttonFontSize),
                NSForegroundColorAttributeName: ThemeManager.current.other
            ]
        }

        /**
         * Website text.
         */
        open static var website: [String: Any] {
            return [
                NSFontAttributeName: UIFont.systemFont(ofSize: UIFont.systemFontSize),
                NSForegroundColorAttributeName: ThemeManager.current.other
            ]
        }

    }

    // MARK: - Auth

    /**
     * Auth styles.
     */
    open class auth {

        /**
         * AuthRequiredNode styles.
         */
        open static var title: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.titleFont,
                NSForegroundColorAttributeName: ThemeManager.current.secondaryText
            ]
        }

    }

    // MARK: - User

    /**
     * User styles.
     */
    open class user {

        /**
         * Comment title.
         */
        open static var commentTitle: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.textFont,
                NSForegroundColorAttributeName: ThemeManager.current.secondaryText
            ]
        }

        /**
         * Comment text.
         */
        open static var commentText: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.subtitleFont,
                NSForegroundColorAttributeName: ThemeManager.current.other
            ]
        }

        /**
         * About label.
         */
        open static var aboutLabel: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.subtitleFont,
                NSForegroundColorAttributeName: ThemeManager.current.other
            ]
        }

        /**
         * About value.
         */
        open static var aboutValue: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.titleFont,
                NSForegroundColorAttributeName: ThemeManager.current.secondaryText
            ]
        }

        /**
         * About bio.
         */
        open static var aboutBio: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.textFont,
                NSForegroundColorAttributeName: ThemeManager.current.secondaryText
            ]
        }

    }

    // MARK: - Pager

    /**
     * Pager styles.
     */
    open class pager {

        /**
         * Button bar background
         */
        open static var buttonBarBackground: UIColor {
            return ThemeManager.current.primary
        }

        /**
         * Button bar item background
         */
        open static var buttonBarItemBackground: UIColor {
            return ThemeManager.current.primary
        }

        /**
         * Selected bar background
         */
        open static var selectedBarBackground: UIColor {
            return ThemeManager.current.secondary
        }

        /**
         * Button bar item font
         */
        open static var buttonBarItemFont: UIFont {
            return FontManager.currentFont.textFont
        }

        /**
         * Button bar item title
         */
        open static var buttonBarItemTitle: UIColor {
            return ThemeManager.current.other
        }

        /**
         * Button bar item selected title
         */
        open static var buttonBarItemTitleSelected: UIColor {
            return ThemeManager.current.secondaryText
        }

    }

    // MARK: - Others

    /**
     * TextFieldNode styles.
     */
    open class textField {

        /**
         * Button bar item selected title
         */
        open static var placeholder: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.textFont,
                NSForegroundColorAttributeName: ThemeManager.current.other
            ]
        }

        /**
         * Button bar item selected title
         */
        open static var text: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.textFont,
                NSForegroundColorAttributeName: ThemeManager.current.secondaryText
            ]
        }

    }

    /**
     * Other node styles.
     */
    open class others {

        /**
         * Button bar item selected title
         */
        open static var middleButton: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.subtitleFont,
                NSForegroundColorAttributeName: ThemeManager.current.secondary
            ]
        }

        /**
         * Button bar item selected title
         */
        open static var fullButton: [String: Any] {
            return [
                NSFontAttributeName: FontManager.currentFont.subtitleFont,
                NSForegroundColorAttributeName: ThemeManager.current.primary
            ]
        }

        /**
         * Button bar item selected title
         */
        open static var link: [String: Any] {
            return [
                NSForegroundColorAttributeName: ThemeManager.current.secondary
            ]
        }

    }

}
