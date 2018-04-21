//
//  RestAPI.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/21/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire

class RestAPI {

    // MARK: - Properties

    /**
     * API urls
     */
    open class urls {
        open static let baseUrl = "https://hn.algolia.com/api/v1"

        open static let items = "\(baseUrl)/items/"
        open static let users = "\(baseUrl)/users/"
        open static let searchByRelevance = "\(baseUrl)/search"
        open static let searchByDate = "\(baseUrl)/search_by_date"
    }

    /**
     * Dispatch queue
     */
    static let RestAPIQueue = DispatchQueue(label: "RestAPIQueue")

    // MARK: - Helpers

    static func add(timeRange: SearchTimeRangeType, toParams params: [String: Any]) -> [String: Any] {
        // check if we need to add a time range
        if let startTime = timeRange.startTime {

            var mutableParams = params
            mutableParams["numericFilters"] = "created_at_i>=\(startTime.timeIntervalSince1970)"

            return mutableParams
        }

        return params
    }

    // MARK: - APIs

    static func item(id: Int) -> Promise<Item> {
        return Promise(resolvers: { (fulfill, reject) in
            RestAPIQueue.async {
                Alamofire.request("\(urls.items)\(id)",
                    method: .get,
                    encoding: JSONEncoding.default)
                    .validate()
                    .responseJSON()
                    .then { response, json -> Void in
                        RestAPIQueue.async {
                            let item = Item(withJSON: json)
                            fulfill(item)
                        }
                    }.catch { error in
                        reject(error)
                }
            }
        })
    }

    static func userPosts(id: String, page: Int = 0) -> Promise<AlgoliaResponse> {
        return Promise(resolvers: { (fulfill, reject) in
            RestAPIQueue.async {
                let params: [String: Any] = [
                    "tags" : "story,author_\(id)",
                    "page": page
                ]

                Alamofire.request(urls.searchByDate,
                                  method: .get,
                                  parameters: params,
                                  encoding: URLEncoding.default)
                    .validate()
                    .responseJSON()
                    .then { response, json -> Void in
                        RestAPIQueue.async {
                            let item = AlgoliaResponse(withJSON: json)
                            fulfill(item)
                        }
                    }.catch { error in
                        reject(error)
                }
            }
        })
    }

    static func userComments(id: String, page: Int = 0) -> Promise<AlgoliaResponse> {
        return Promise(resolvers: { (fulfill, reject) in
            RestAPIQueue.async {
                let params: [String: Any] = [
                    "tags" : "comment,author_\(id)",
                    "page": page
                ]

                Alamofire.request(urls.searchByDate,
                                  method: .get,
                                  parameters: params,
                                  encoding: URLEncoding.default)
                    .validate()
                    .responseJSON()
                    .then { response, json -> Void in
                        RestAPIQueue.async {
                            let item = AlgoliaResponse(withJSON: json)
                            fulfill(item)
                        }
                    }.catch { error in
                        reject(error)
                }
            }
        })
    }

    static func searchStories(query: String, timeRange: SearchTimeRangeType = .all, sortBy: SearchSortType = .relevance, page: Int = 0) -> Promise<AlgoliaResponse> {
        return Promise(resolvers: { (fulfill, reject) in
            RestAPIQueue.async {
                var params: [String: Any] = [
                    "query": query,
                    "tags" : "story",
                    "page": page
                ]

                params = add(timeRange: timeRange, toParams: params)

                Alamofire.request("\(urls.baseUrl)\(sortBy.url)",
                                  method: .get,
                                  parameters: params,
                                  encoding: URLEncoding.default)
                    .validate()
                    .responseJSON()
                    .then { response, json -> Void in
                        RestAPIQueue.async {
                            let item = AlgoliaResponse(withJSON: json)
                            fulfill(item)
                        }
                    }.catch { error in
                        reject(error)
                }
            }
        })
    }

    static func searchComments(query: String, timeRange: SearchTimeRangeType = .all, sortBy: SearchSortType = .relevance, page: Int = 0) -> Promise<AlgoliaResponse> {
        return Promise(resolvers: { (fulfill, reject) in
            RestAPIQueue.async {
                var params: [String: Any] = [
                    "query": query,
                    "tags" : "comment",
                    "page": page,
                ]

                params = add(timeRange: timeRange, toParams: params)

                Alamofire.request("\(urls.baseUrl)\(sortBy.url)",
                                  method: .get,
                                  parameters: params,
                                  encoding: URLEncoding.default)
                    .validate()
                    .responseJSON()
                    .then { response, json -> Void in
                        RestAPIQueue.async {
                            let item = AlgoliaResponse(withJSON: json)
                            fulfill(item)
                        }
                    }.catch { error in
                        reject(error)
                }
            }
        })
    }

}
