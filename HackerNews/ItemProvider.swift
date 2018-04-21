//
//  Model.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/10/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Foundation
import PromiseKit
import PINCache

class ItemProvider {

    // MARK: - Read items

    static var readItems: [Int] = {
        return PINCache.shared.object(forKey: "readItems") as? [Int] ?? []
    }()

    static func read(itemWithId id: Int) {
        // if we already read the item
        if let index = self.readItems.index(of: id) {
            // remove it
            self.readItems.remove(at: index)
        }
        // add the item to the front
        self.readItems.insert(id, at: 0)

        // save the list in cache
        PINCache.shared.setObject(self.readItems as NSCoding, forKey: "readItems", block: nil)
    }

    static func didRead(itemWithId id: Int) -> Bool {
        return self.readItems.contains(id)
    }

    // MARK: - Stories

    static func stories(ofType type: StoryType) -> [Int] {
        return PINCache.shared.object(forKey: type.value) as? [Int] ?? []
    }

    static func set(stories: [Int], forType type: StoryType) {
        PINCache.shared.setObject(stories as NSCoding, forKey: type.value)
    }

    // MARK: - Items

    static func add(item: Item) -> Promise<Void> {
        return Promise(resolvers: { (fulfill, reject) in
            PINCache.shared.setObject(item, forKey: "\(item.id)") { (cache, key, object) in
                fulfill()
            }
        })
    }

    static func add(items: [Item]) -> Promise<Void> {
        return Promise(resolvers: { (fulfill, reject) in
            var calls: [Promise<Void>] = []

            for i in 0..<items.count {
                calls.append(self.add(item: items[i]))
            }

            let _ = when(fulfilled: calls).then {
                fulfill()
            }
        })
    }

    static func item(withId id: Int) -> Item? {
        return PINCache.shared.object(forKey: "\(id)") as? Item
    }

    // MARK: - Users

    static func add(user: User) -> Promise<Void> {
        return Promise(resolvers: { (fulfill, reject) in
            PINCache.shared.setObject(user, forKey: "user:\(user.id)") { (cache, key, object) in
                fulfill()
            }
        })
    }

    static func user(withId id: String) -> User? {
        return PINCache.shared.object(forKey: "user:\(id)") as? User
    }

    // MARK: - Current user

    static func set(currentUser user: User) {
        PINCache.shared.setObject(user, forKey: "currentUser")
    }

    static func currentUser() -> User {
        return PINCache.shared.object(forKey: "currentUser") as? User ?? User()
    }

    // MARK: - Voted items

    static func vote(item: Item) {
        PINCache.shared.setObject(true as NSCoding, forKey: "v:\(item.id)")
    }

    static func didVote(item: Item) -> Bool {
        return PINCache.shared.containsObject(forKey: "v:\(item.id)")
    }

    static func removeVote(item: Item) {
        PINCache.shared.removeObject(forKey: "v:\(item.id)")
    }

    // MARK: - Helpers

    static func clear(toDate date: Date) {
        PINCache.shared.trim(to: date)
        self.readItems.removeAll()
        NotificationCenter.default.post(Constants.kClearCacheNotification)
    }

}
