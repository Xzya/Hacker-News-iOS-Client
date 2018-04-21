//
//  StoryType.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/30/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Foundation

enum StoryType: OptionType {
    case top
    case new
    case best
    case ask
    case show
    case job

    var title: String {
        switch self {
        case .top:
            return "Top"
        case .new:
            return "New"
        case .best:
            return "Best"
        case .ask:
            return "Ask"
        case .show:
            return "Show"
        case .job:
            return "Job"
        }
    }

    var icon: IonIconType {
        switch self {
        default:
            return .ion_ios_star
        }
    }

    var value: String {
        switch self {
        case .top:
            return "topstories"
        case .new:
            return "newstories"
        case .best:
            return "beststories"
        case .ask:
            return "askstories"
        case .show:
            return "showstories"
        case .job:
            return "jobstories"
        }
    }

    static var values: [StoryType] {
        return [
            top,
            new,
            best,
            ask,
            show,
            job,
        ]
    }

    static func initWithValue(value: String) -> StoryType? {
        for type in values {
            if type.value == value {
                return type
            }
        }
        return nil
    }

}
