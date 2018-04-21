//
//  HNAPI.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/9/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire

class HNAPI {

    static let HNAPIQueue = DispatchQueue(label: "HNAPIQueue")

    static func stories(ofType type: StoryType) -> Promise<[Int]> {
        return FirebaseAPI.stories(ofType: type)
    }

    static func item(id: Int) -> Promise<Item> {
        return FirebaseAPI.item(id: id)
    }

    static func itemDetails(id: Int) -> Promise<Item> {
        return RestAPI.item(id: id)
    }

    static func user(id: String) -> Promise<User> {
        return FirebaseAPI.user(id: id)
    }

    static func userPosts(id: String, page: Int = 0) -> Promise<AlgoliaResponse> {
        return RestAPI.userPosts(id: id, page: page)
    }

    static func userComments(id: String, page: Int = 0) -> Promise<AlgoliaResponse> {
        return RestAPI.userComments(id: id, page: page)
    }

    static func searchStories(query: String, timeRange: SearchTimeRangeType = .all, sortBy: SearchSortType = .relevance, page: Int = 0) -> Promise<AlgoliaResponse> {
        return RestAPI.searchStories(query: query, timeRange: timeRange, sortBy: sortBy, page: page)
    }

    static func searchComments(query: String, timeRange: SearchTimeRangeType = .all, sortBy: SearchSortType = .relevance, page: Int = 0) -> Promise<AlgoliaResponse> {
        return RestAPI.searchComments(query: query, timeRange: timeRange, sortBy: sortBy, page: page)
    }

    static func vote(item: Item, up: Bool = true) -> Promise<Void> {
        return SiteAPI.vote(item: item, up: up)
    }

    static func login(username: String, password: String) -> Promise<Void> {
        return SiteAPI.login(username: username, password: password)
    }

    static func register(username: String, password: String) -> Promise<String> {
        return SiteAPI.register(username: username, password: password)
    }

    static func postStory(title: String, url: String?, text: String?) -> Promise<Void> {
        return SiteAPI.postStory(title: title, url: url, text: text)
    }

}
