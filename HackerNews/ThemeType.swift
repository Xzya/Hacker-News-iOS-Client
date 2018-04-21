//
//  ThemeType.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/30/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Foundation

enum ThemeType: OptionType {
    case dark
    case light
    case blue
    case orange

    var value: String {
        switch self {
        case .dark:
            return "dark"
        case .light:
            return "light"
        case .blue:
            return "blue"
        case .orange:
            return "orange"
        }
    }

    var title: String {
        switch self {
        case .dark:
            return "Dark"
        case .light:
            return "Light"
        case .blue:
            return "Blue"
        case .orange:
            return "Orange"
        }
    }

    var icon: IonIconType {
        return .ion_android_color_palette
    }

    static var values: [ThemeType] {
        return [
            dark,
            light,
            blue,
            orange,
        ]
    }

    static func initWithValue(value: String) -> ThemeType? {
        for type in values {
            if type.value == value {
                return type
            }
        }
        return nil
    }

}
