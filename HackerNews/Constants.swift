//
//  Constants.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/9/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit

class Constants {

    static let kFirebaseURL = "https://hacker-news.firebaseio.com/v0/"
    static let kLoginURL = "https://news.ycombinator.com/login"
    static let kHackerNewsURL = "https://news.ycombinator.com/"
    static let kForgotPasswordURL = "https://news.ycombinator.com/forgot"

    static let kTextLinkAttributeName = "TextLinkAttributeName"

    static let kItemExpiratinTime: TimeInterval = 60
    static let kHomePreloadItemCount: Int = 10
    static let kCommentsPreloadItemCount: Int = 25

    static let kClearCacheNotification: Notification = Notification(name: Notification.Name("kClearCacheNotification"))
    static let kSearchNotification: Notification = Notification(name: Notification.Name("kSearchNotification"))
    static let kLoginNotification: Notification = Notification(name: Notification.Name("kLoginNotification"))

}
