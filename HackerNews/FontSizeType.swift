//
//  FontSizeType.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/30/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Foundation

enum FontSizeType: OptionType {
    case smallest
    case small
    case `default`
    case large
    case largest

    var value: String {
        switch self {
        case .smallest:
            return "smaller"
        case .small:
            return "small"
        case .default:
            return "default"
        case .large:
            return "large"
        case .largest:
            return "largest"
        }
    }

    var title: String {
        switch self {
        case .smallest:
            return "Smallest"
        case .small:
            return "Small"
        case .default:
            return "Default"
        case .large:
            return "Large"
        case .largest:
            return "Largest"
        }
    }

    var icon: IonIconType {
        switch self {
        default:
            return .ion_arrow_resize
        }
    }

    static var values: [FontSizeType] {
        return [
            smallest,
            small,
            `default`,
            large,
            largest
        ]
    }

    static func initWithValue(value: String) -> FontSizeType? {
        for type in values {
            if type.value == value {
                return type
            }
        }
        return nil
    }

}
