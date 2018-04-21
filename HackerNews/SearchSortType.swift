//
//  SearchSortType.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 6/3/17.
//  Copyright © 2017 Null. All rights reserved.
//

import Foundation

enum SearchSortType: OptionType {
    case relevance
    case date

    var title: String {
        switch self {
        case .relevance:
            return "Most relevant"
        case .date:
            return "Most recent"
        }
    }

    var icon: IonIconType {
        switch self {
        case .relevance:
            return .ion_ios_checkmark
        case .date:
            return .ion_ios_clock
        }
    }

    var value: String {
        switch self {
        case .relevance:
            return "relevant"
        case .date:
            return "date"
        }
    }

    var url: String {
        switch self {
        case .relevance:
            return "/search"
        case .date:
            return "/search_by_date"
        }
    }

    static var values: [SearchSortType] {
        return [
            relevance,
            date,
        ]
    }

    static func initWithValue(value: String) -> SearchSortType? {
        for type in values {
            if type.value == value {
                return type
            }
        }
        return nil
    }

    static let label: String = "Sort by"

}
