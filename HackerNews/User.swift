//
//  User.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/29/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {

    // MARK: - Properties

    var id: String = ""
    var about: String = ""
    var created: TimeInterval = 0
    var karma: Int = 0

    var posts: [Item] = []
    var comments: [Item] = []

    static var sharedInstance: User = {
        return ItemProvider.currentUser()
    }()

    // MARK: - Inits

    override init() {
        super.init()

        self.setData(withJSON: [:])
    }

    init(withJSON json: [String: AnyObject]) {
        super.init()

        self.setData(withJSON: json)
    }

    init(username: String) {
        super.init()

        self.setData(withJSON: [:])

        self.id = username
    }

    func setData(withJSON json: [String: AnyObject]) {
        self.id = json["id"] as? String ?? self.id
        self.about = json["about"] as? String ?? self.about
        self.created = json["created"] as? TimeInterval ?? self.created
        self.karma = json["karma"] as? Int ?? self.karma

        self.about = self.about.stringByDecodingXMLEntities().stringByRemovingHTMLTags()
    }

    // MARK: - Coder

    required public init?(coder aDecoder: NSCoder) {
        super.init()

        self.id = aDecoder.decodeObject(forKey: "id") as? String ?? self.id
        self.about = aDecoder.decodeObject(forKey: "about") as? String ?? self.about
        self.created = aDecoder.decodeDouble(forKey: "created")
        self.karma = aDecoder.decodeInteger(forKey: "karma")

        self.posts = aDecoder.decodeObject(forKey: "posts") as? [Item] ?? self.posts
        self.comments = aDecoder.decodeObject(forKey: "comments") as? [Item] ?? self.comments
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.about, forKey: "about")
        aCoder.encode(self.created, forKey: "created")
        aCoder.encode(self.karma, forKey: "karma")

        aCoder.encode(self.posts, forKey: "posts")
        aCoder.encode(self.comments, forKey: "comments")
    }

    // MARK: - Helpers

    static func userWebURL(user: String) -> String {
        return "https://news.ycombinator.com/user?id=\(user)"
    }

    func isLoggedIn() -> Bool {
        if let cookies = HTTPCookieStorage.shared.cookies(for: URL(string: Constants.kHackerNewsURL)!) {
            for cookie in cookies {
                if cookie.name == "user" && !cookie.name.isEmpty {
                    return true
                }
            }
        }

        return false
    }

    func logout() {
        if let cookies = HTTPCookieStorage.shared.cookies(for: URL(string: Constants.kHackerNewsURL)!) {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        User.sharedInstance = User()
        ItemProvider.set(currentUser: User.sharedInstance)
        ItemProvider.clear(toDate: Date())
    }

}
