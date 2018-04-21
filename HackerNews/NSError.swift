//
//  NSError.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/11/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Foundation
import Firebase

extension NSError {

    static func from(item: Item) -> NSError {
        return NSError(domain: "HACKER_NEWS", code: -1, userInfo: [
            "id": item.id
            ])
    }

    static func from(snapshot: DataSnapshot) -> NSError {
        return NSError(domain: "FIREBASE", code: -1, userInfo: [
            "snapshot": snapshot.debugDescription
            ])
    }

    static func from(string: String) -> NSError {
        return NSError(domain: "HACKER_NEWS", code: -1, userInfo: [
            NSLocalizedDescriptionKey: string
            ])
    }

}
