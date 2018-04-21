//
//  SiteAPI.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/12/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire

class SiteAPI {

    open class urls {

        static let baseUrl = "https://news.ycombinator.com"

        static let login = "\(baseUrl)/login"
        static let register = "\(baseUrl)/login"

        static let submit = "\(baseUrl)/submit"
        static let reply = "\(baseUrl)/r"

        static let deleteStory = "\(baseUrl)/delete-confirm?id="
        static let delete = "\(baseUrl)/xdelete"

    }

    static let SiteAPIQueue = DispatchQueue(label: "SiteAPIQueue")

    static func login(username: String, password: String) -> Promise<Void> {
        return Promise(resolvers: { (fulfill, reject) in
            SiteAPIQueue.async {
                let params: [String: Any] = [
                    "acct": username,
                    "pw": password
                ]

                Alamofire.request(urls.login,
                                  method: .post,
                                  parameters: params,
                                  encoding: URLEncoding.default,
                                  headers: nil)
                    .responseString()
                    .then { response, result -> Void in
                        if User.sharedInstance.isLoggedIn() {
                            fulfill()
                            return;
                        }
                        reject(NSError.from(string: "Bad credentials"))
                    }.catch { error in
                        reject(error)
                }
            }
        })
    }

    static func register(username: String, password: String) -> Promise<String> {
        return Promise(resolvers: { (fulfill, reject) in
            SiteAPIQueue.async {
                let params: [String: Any] = [
                    "acct": username,
                    "pw": password,
                    "creating": "t"
                ]

                Alamofire.request(urls.register,
                                  method: .post,
                                  parameters: params,
                                  encoding: URLEncoding.default,
                                  headers: nil)
                    .responseString()
                    .then { response, result -> Void in
                        if User.sharedInstance.isLoggedIn() {
                            fulfill(result)
                            return;
                        }
                        if result.matches(for: "captcha").count > 0 {
                            fulfill(result)
                            return;
                        }
                        reject(NSError.from(string: "Bad login"))
                    }.catch { error in
                        reject(error)
                }
            }
        })
    }

    static func vote(item: Item, up: Bool = true) -> Promise<Void> {
        return Promise(resolvers: { (fulfill, reject) in
            SiteAPIQueue.async {
                Alamofire.request(item.itemWebURL, method: .get)
                    .validate()
                    .responseString()
                    .then { response, result -> Void in
                        SiteAPIQueue.async {

                            let voteString = "vote\\?id=\(item.id).+how=\(up ? "up" : "un")(.*?)(\\\"|\\\')"

                            let matches = result.matches(for: voteString)

                            if matches.count > 0 {

                                let voteQuery = matches[0]
                                    .replacingOccurrences(of: "'", with: "")
                                    .replacingOccurrences(of: "\"", with: "")
                                let voteURL = "\(Constants.kHackerNewsURL)\(voteQuery)".stringByDecodingXMLEntities()

                                self.vote(withURL: voteURL)
                                    .then { Void -> Void in
                                        fulfill()
                                    }.catch { error in
                                        reject(error)
                                }
                            } else {
                                reject(NSError.from(string: "Failed to vote item"))
                            }
                        }
                    }.catch { error in
                        reject(error)
                }
            }
        })
    }

    private static func vote(withURL url: String) -> Promise<Void> {
        return Promise(resolvers: { (fulfill, reject) in
            SiteAPIQueue.async {
                Alamofire.request(url, method: .get)
                    .validate()
                    .responseString()
                    .then { response, result -> Void in
                        fulfill()
                    }.catch { error in
                        reject(error)
                }
            }
        })
    }

    static func postStory(title: String, url: String?, text: String?) -> Promise<Void> {
        return Promise(resolvers: { (fulfill, reject) in
            SiteAPIQueue.async {

                // first, load the submit page
                Alamofire.request(urls.submit, method: .get)
                    .validate()
                    .responseString()
                    .then { response, result -> Void in
                        SiteAPIQueue.async {

                            // get the fnid
                            if let fnid = result.getFnid() {

                                // params
                                var params: [String: Any] = [
                                    "fnid": fnid,
                                    "title": title,
                                    "fnop": "submit-page",
                                    "url": "",
                                    "text": ""
                                ]

                                // add the url or text
                                if let url = url {
                                    params["url"] = url
                                } else if let text = text {
                                    params["text"] = text
                                }

                                let headers = [
                                    "Content-Type": "application/x-www-form-urlencoded"
                                ]

                                // now make the post request with the data
                                Alamofire.request(urls.reply, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers)
                                    .validate()
                                    .responseString()
                                    .then { response, result -> Void in
                                        SiteAPIQueue.async {

                                            // successful if status 200 and the url matches newest page
                                            if response.response?.statusCode == 200 && response.response?.url?.absoluteString.hasNewestPage() == true {
                                                fulfill()
                                            }
                                            // submitting too fast
                                            else if result.isSubmittingTooFast() {
                                                reject(NSError.from(string: "You are submitting too fast."))
                                            }
                                            // the url already exists, so it's a duplicate post
                                            else if result.isDuplicate() {
                                                reject(NSError.from(string: "The post already exists."))
                                            }
                                            // else, assume success
                                            else {
                                                fulfill()
                                            }

                                        }
                                    }.catch { error in
                                        reject(error)
                                }

                            } else {
                                reject(NSError.from(string: "An error occured."))
                            }

                        }
                    }.catch { error in
                        reject(error)
                }
            }
        })
    }

    static func deleteStory(id: Int) -> Promise<Void> {
        return Promise(resolvers: { (fulfill, reject) in
            SiteAPIQueue.async {

                // first, load the confirmation page
                Alamofire.request("\(urls.deleteStory)\(id)", method: .get)
                    .validate()
                    .responseString()
                    .then { response, result -> Void in
                        SiteAPIQueue.async {

                            // get the hmac
                            if let hmac = result.getHmac() {

                                // params
                                let params: [String: Any] = [
                                    "id": id,
                                    "hmac": hmac,
                                    "goto": "newest",
                                    "d": "Yes",
                                ]

                                let headers = [
                                    "Content-Type": "application/x-www-form-urlencoded"
                                ]

                                // now make the post request with the data
                                Alamofire.request(urls.delete, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers)
                                    .validate()
                                    .responseString()
                                    .then { response, result -> Void in
                                        SiteAPIQueue.async {

                                            // TODO: - Some error handling here? No idea, it seems you always get
                                            // status 200 and the news
                                            // If we got the hmac in the confirmation and the request didn't fail
                                            // it should be fine.
                                            fulfill()

                                        }
                                    }.catch { error in
                                        reject(error)
                                }

                            } else {
                                reject(NSError.from(string: "An error occured."))
                            }

                        }
                    }.catch { error in
                        reject(error)
                }
            }
        })
    }

}
