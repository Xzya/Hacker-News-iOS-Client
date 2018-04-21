//
//  FirebaseAPI.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/21/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Foundation
import Firebase
import PromiseKit

class FirebaseAPI {

    static var ref: DatabaseReference = {
        return Database.database().reference(fromURL: Constants.kFirebaseURL)
    }()

    static var topstoriesRef: DatabaseReference {
        return ref.child("topstories")
    }

    static var newstoriesRef: DatabaseReference {
        return ref.child("newstories")
    }

    static var beststoriesRef: DatabaseReference {
        return ref.child("beststories")
    }

    static var askstoriesRef: DatabaseReference {
        return ref.child("askstories")
    }

    static var showstoriesRef: DatabaseReference {
        return ref.child("showstories")
    }

    static var jobstoriesRef: DatabaseReference {
        return ref.child("jobstories")
    }

    static var itemRef: DatabaseReference {
        return ref.child("item")
    }

    static var userRef: DatabaseReference {
        return ref.child("user")
    }

    static let FirebaseAPIQueue = DispatchQueue(label: "FirebaseAPIQueue")

    static func item(id: Int) -> Promise<Item> {
        return Promise.init(resolvers: { (fullfill, reject) in
            FirebaseAPIQueue.async {
                self.itemRef.child("\(id)").observeSingleEvent(of: .value, with: { (snapshot) in
                    FirebaseAPIQueue.async {
                        if let json = snapshot.value as? [String: AnyObject] {
                            fullfill(Item(withFirebaseJSON: json))
                            return;
                        }
                        reject(NSError.from(snapshot: snapshot))
                    }
                }) { (error) in
                    reject(error)
                }
            }
        })
    }

    static func user(id: String) -> Promise<User> {
        return Promise.init(resolvers: { (fullfill, reject) in
            FirebaseAPIQueue.async {
                self.userRef.child("\(id)").observeSingleEvent(of: .value, with: { (snapshot) in
                    FirebaseAPIQueue.async {
                        if let json = snapshot.value as? [String: AnyObject] {
                            fullfill(User(withJSON: json))
                            return;
                        }
                        reject(NSError.from(snapshot: snapshot))
                    }
                }) { (error) in
                    reject(error)
                }
            }
        })
    }

    static func stories(ofType type: StoryType) -> Promise<[Int]> {
        return Promise.init(resolvers: { (fullfill, reject) in
            FirebaseAPIQueue.async {
                self.ref.child(type.value).observeSingleEvent(of: .value, with: { (snapshot) in
                    FirebaseAPIQueue.async {
                        if let stories = snapshot.value as? [Int] {
                            fullfill(stories)
                            return;
                        }
                        reject(NSError.from(snapshot: snapshot))
                    }
                }) { (error) in
                    reject(error)
                }
            }
        })
    }

}
