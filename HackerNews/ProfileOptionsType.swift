//
//  ProfileOptionsType.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/12/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Foundation

enum ProfileOptionsType: OptionType {
    case history
    case posts
    case comments
    case logout

    var title: String {
        switch self {
        case .history:
            return "History"
        case .posts:
            return "My posts"
        case .comments:
            return "My comments"
        case .logout:
            return "Logout"
        }
    }

    var icon: IonIconType {
        switch self {
        case .history:
            return .ion_ios_clock
        case .posts:
            return .ion_ios_list
        case .comments:
            return .ion_chatbox
        case .logout:
            return .ion_log_out
        }
    }

    static var values: [ProfileOptionsType] {
        return [
            history,
            posts,
            comments,
            logout
        ]
    }

}
