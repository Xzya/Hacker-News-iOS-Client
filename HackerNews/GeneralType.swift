//
//  GeneralType.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/30/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Foundation

enum GeneralType: OptionType {
    case cancel
    case none
    case close

    var title: String {
        switch self {
        case .cancel:
            return "Cancel"
        case .none:
            return ""
        case .close:
            return "Close"
        }
    }

    var icon: IonIconType {
        switch self {
        case .cancel:
            return .ion_close
        case .none:
            return .ion_ios_help
        case .close:
            return .ion_checkmark_round
        }
    }

    static var values: [GeneralType] {
        return [
            none,
            cancel,
            close,
        ]
    }

}
