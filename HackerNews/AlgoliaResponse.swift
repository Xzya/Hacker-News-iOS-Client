//
//  AlgoliaResponse.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/5/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Foundation

class AlgoliaResponse: NSObject {

    // MARK: - Properties

    var hits: [Item] = []
    var hitCount: Int = 0
    var page: Int = 0
    var pageCount: Int = 0
    var hitsPerPage: Int = 0

    // MARK: - Inits

    override init() {
        super.init()

        self.setData(withJSON: [:])
    }

    init(withJSON json: [String: AnyObject]) {
        super.init()

        self.setData(withJSON: json)
    }

    func setData(withJSON json: [String: AnyObject]) {
        self.hitCount = json["nbHits"] as? Int ?? self.hitCount
        self.page = json["page"] as? Int ?? self.page
        self.pageCount = json["nbPages"] as? Int ?? self.pageCount
        self.hitsPerPage = json["hitsPerPage"] as? Int ?? self.hitsPerPage

        if let hits = json["hits"] as? [[String: AnyObject]] {
            for hit in hits {
                self.hits.append(Item(withAlgoliaJSON: hit))
            }
        }
    }

}
