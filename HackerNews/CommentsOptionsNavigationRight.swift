//
//  CommentsOptionsNavigationRight.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/30/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Foundation

enum CommentsOptionsNavigationRight: OptionType {
    case openInBrowser

    var title: String {
        switch self {
        case .openInBrowser:
            return "kOpenInBrowser".localized
        }
    }

    var icon: IonIconType {
        switch self {
        case .openInBrowser:
            return .ion_earth
        }
    }

    static var values: [CommentsOptionsNavigationRight] {
        return [
            openInBrowser
        ]
    }

}
