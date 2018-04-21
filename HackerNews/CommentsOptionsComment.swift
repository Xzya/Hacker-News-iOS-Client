//
//  CommentsOptionsComment.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/30/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Foundation

enum CommentsOptionsComment: OptionType {
    case share
    case copy
    case openInBrowser

    var title: String {
        switch self {
        case .share:
            return "kShare".localized
        case .copy:
            return "kCopy".localized
        case .openInBrowser:
            return "kOpenInBrowser".localized
        }
    }

    var icon: IonIconType {
        switch self {
        case .share:
            return .ion_ios_upload
        case .copy:
            return .ion_ios_copy
        case .openInBrowser:
            return .ion_earth
        }
    }

    static var values: [CommentsOptionsComment] {
        return [
            share,
            copy,
            openInBrowser,
        ]
    }

}
