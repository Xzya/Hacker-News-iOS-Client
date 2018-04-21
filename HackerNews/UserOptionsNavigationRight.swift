//
//  UserOptionsNavigationRight.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/6/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Foundation

enum UserOptionsNavigationRight: OptionType {
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

    static var values: [UserOptionsNavigationRight] {
        return [
            openInBrowser
        ]
    }

}
