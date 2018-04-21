//
//  SettingsType.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/30/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Foundation

enum SettingsType: OptionType {
    case defaultStoryType
    case font
    case fontSize
    case theme
    case clearCache

    case none

    var value: String {
        switch self {
        case .defaultStoryType:
            return "defaultStoryType"
        case .font:
            return "font"
        case .fontSize:
            return "fontSize"
        case .theme:
            return "theme"
        case .clearCache:
            return "clearCache"
        default:
            return ""
        }
    }

    var title: String {
        switch self {
        case .defaultStoryType:
            return "Default story type"
        case .font:
            return "Font"
        case .fontSize:
            return "Font size"
        case .theme:
            return "Theme"
        case .clearCache:
            return "Clear cache"
        default:
            return ""
        }
    }

    var icon: IonIconType {
        switch self {
        case .defaultStoryType:
            return .ion_social_rss
        case .font:
            return .ion_ios_list
        case .fontSize:
            return .ion_arrow_resize
        case .theme:
            return .ion_android_color_palette
        case .clearCache:
            return .ion_trash_a
        default:
            return .ion_ios_help
        }
    }

    static var values: [SettingsType] {
        return [
            defaultStoryType,
            font,
            fontSize,
            theme,
            clearCache
        ]
    }

    static func initWithValue(value: String) -> SettingsType? {
        for type in values {
            if type.value == value {
                return type
            }
        }
        return nil
    }

}
