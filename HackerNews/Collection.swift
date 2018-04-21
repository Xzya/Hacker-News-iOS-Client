//
//  Collection.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/5/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Iterator.Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
}
