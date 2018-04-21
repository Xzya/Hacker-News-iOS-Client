//
//  WebOptionType.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/3/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Foundation

enum WebOptionType: OptionType {
    case refresh
    case share
    case openInBrowser

    var title: String {
        switch self {
        case .refresh:
            return "kRefresh".localized
        case .share:
            return "kShare".localized
        case .openInBrowser:
            return "kOpenInBrowser".localized
        }
    }

    var icon: IonIconType {
        switch self {
        case .refresh:
            return .ion_refresh
        case .share:
            return .ion_ios_upload
        case .openInBrowser:
            return .ion_earth
        }
    }

    static var values: [WebOptionType] {
        return [
            refresh,
            share,
            openInBrowser,
        ]
    }

}
