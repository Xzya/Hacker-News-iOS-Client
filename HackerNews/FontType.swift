//
//  FontType.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/30/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Foundation

enum FontType: OptionType {
    case `default`
    case helvetica
    case helveticaNeue
    case georgia
    case timesNewRoman
    case trebuchetMS
    case courier
    case courierNew
    case arial
    case avenir

    var value: String {
        switch self {
        case .default:
            return "default"
        case .helvetica:
            return "helvetica"
        case .helveticaNeue:
            return "helveticaNeue"
        case .georgia:
            return "georgia"
        case .timesNewRoman:
            return "timesNewRoman"
        case .trebuchetMS:
            return "trebuchetMS"
        case .courier:
            return "courier"
        case .courierNew:
            return "courierNew"
        case .arial:
            return "arial"
        case .avenir:
            return "avenir"
        }
    }

    var title: String {
        switch self {
        case .default:
            return "Default"
        case .helvetica:
            return "Helvetica"
        case .helveticaNeue:
            return "Helvetica Neue"
        case .georgia:
            return "Georgia"
        case .timesNewRoman:
            return "Times New Roman"
        case .trebuchetMS:
            return "Trebuchet MS"
        case .courier:
            return "Courier"
        case .courierNew:
            return "Courier New"
        case .arial:
            return "Arial"
        case .avenir:
            return "Avenir"
        }
    }

    var icon: IonIconType {
        switch self {
        default:
            return .ion_ios_list
        }
    }

    static var values: [FontType] {
        return [
            `default`,
            helvetica,
            helveticaNeue,
            georgia,
            timesNewRoman,
            trebuchetMS,
            courier,
            arial,
            avenir,
        ]
    }

    static func initWithValue(value: String) -> FontType? {
        for type in values {
            if type.value == value {
                return type
            }
        }
        return nil
    }

}
