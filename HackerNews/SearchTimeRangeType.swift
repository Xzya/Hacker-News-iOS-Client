//
//  SearchTimeType.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 6/3/17.
//  Copyright © 2017 Null. All rights reserved.
//

import Foundation

enum SearchTimeRangeType: OptionType {
    case all
    case day
    case week
    case month
    case year

    var title: String {
        switch self {
        case .all:
            return "All time"
        case .day:
            return "Last 24h"
        case .week:
            return "Last week"
        case .month:
            return "Last month"
        case .year:
            return "Last year"
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
        case .all:
            return "all"
        case .day:
            return "day"
        case .week:
            return "week"
        case .month:
            return "month"
        case .year:
            return "year"
        }
    }

    var startTime: Date? {
        let calendar = Calendar.current

        switch self {

        case .all:

            // in case we want all results, simply ignore the time
            return nil

        case .day:

            return calendar.date(byAdding: .day, value: -1, to: Date(), wrappingComponents: false)

        case .week:

            return calendar.date(byAdding: .day, value: -7, to: Date(), wrappingComponents: false)

        case .month:

            return calendar.date(byAdding: .month, value: -1, to: Date(), wrappingComponents: false)

        case .year:

            return calendar.date(byAdding: .year, value: -1, to: Date(), wrappingComponents: false)
        }

    }

    static var values: [SearchTimeRangeType] {
        return [
            all,
            day,
            week,
            month,
            year,
        ]
    }

    static func initWithValue(value: String) -> SearchTimeRangeType? {
        for type in values {
            if type.value == value {
                return type
            }
        }
        return nil
    }

    static let label: String = "Since"

}
