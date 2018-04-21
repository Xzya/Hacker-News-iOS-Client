//
//  Item.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/9/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Foundation

enum ItemType: String {
    case job = "job"
    case story = "story"
    case comment = "comment"
    case poll = "poll"
    case pollopt = "pollopt"
    case none = "none"
}

class Item: NSObject, NSCoding {

    // MARK: - Properties

    var type: ItemType = .none
    var id: Int = -1
    var by: String = ""
    var time: TimeInterval = 0
    var descendants: Int = 0
    var score: Int = 0
    var title: String = ""
    var text: String = ""
    var url: String = ""
    var parent: Int = -1
    var dateAdded: Date = Date()
    var storyId: Int = -1
    var storyTitle: String = ""
    var storyText: String = ""
    var storyUrl: String = ""

    var level: Int = 0
    var itemWebURL: String {
        return "https://news.ycombinator.com/item?id=\(self.id)"
    }
    var isLoaded: Bool = false

    var children: [Item] = []

    // MARK: - Inits

    override init() {
        super.init()

        self.setData(withJSON: [:])
    }

    init(withJSON json: [String: AnyObject], parseChildren: Bool = true) {
        super.init()

        self.setData(withJSON: json, parseChildren: parseChildren)
    }

    init(withAlgoliaJSON json: [String: AnyObject]) {
        super.init()

        self.setData(withAlgoliaJSON: json)
    }

    init(withFirebaseJSON json: [String: AnyObject]) {
        super.init()

        self.setData(withFirebaseJSON: json)
    }

    func setData(withFirebaseJSON json: [String: AnyObject]) {
        self.type = ItemType(rawValue: json["type"] as? String ?? "") ?? self.type
        self.id = json["id"] as? Int ?? self.id
        self.by = json["by"] as? String ?? self.by
        self.score = json["score"] as? Int ?? self.score
        self.time = json["time"] as? TimeInterval ?? self.time
        self.title = json["title"] as? String ?? self.title
        self.url = json["url"] as? String ?? self.url
        self.text = (json["text"] as? String ?? self.text).stringByRemovingHTMLTags().stringByDecodingXMLEntities()
        self.parent = json["parent"] as? Int ?? self.parent
        self.descendants = json["descendants"] as? Int ?? self.descendants

        self.isLoaded = false

    }

    func setData(withJSON json: [String: AnyObject], parseChildren: Bool = true) {
        self.type = ItemType(rawValue: json["type"] as? String ?? "") ?? self.type
        self.id = json["id"] as? Int ?? self.id
        self.by = json["author"] as? String ?? self.by
        self.score = json["points"] as? Int ?? self.score
        self.time = json["created_at_i"] as? TimeInterval ?? self.time
        self.title = json["title"] as? String ?? self.title
        self.url = json["url"] as? String ?? self.url
        self.text = json["text"] as? String ?? self.text
        self.parent = json["parent_id"] as? Int ?? self.parent

        self.text = self.text.stringByRemovingHTMLTags().stringByDecodingXMLEntities()

        self.isLoaded = true

        if parseChildren {
            self.children.append(contentsOf: self.parseChildren(withJSON: json))

            self.descendants = self.children.count
        }
    }

    func setData(withAlgoliaJSON json: [String: AnyObject]) {
        if let tags = json["_tags"] as? [String] {
            self.type = tags.contains("story") ? .story : tags.contains("comment") ? .comment : .none
        }

        self.id = Int(json["objectID"] as? String ?? "") ?? self.id
        self.by = json["author"] as? String ?? self.by
        self.score = json["points"] as? Int ?? self.score
        self.time = json["created_at_i"] as? TimeInterval ?? self.time
        self.url = json["url"] as? String ?? self.url
        self.parent = json["parent_id"] as? Int ?? self.parent
        self.descendants = json["num_comments"] as? Int ?? self.descendants


        if self.type == .story {
            self.title = json["title"] as? String ?? self.title
            self.text = json["story_text"] as? String ?? self.text
        } else {
            self.text = json["comment_text"] as? String ?? self.text
            self.storyTitle = json["story_title"] as? String ?? self.storyTitle
            self.storyText = json["story_text"] as? String ?? self.storyText
            self.storyId = json["story_id"] as? Int ?? self.storyId
            self.storyUrl = json["story_url"] as? String ?? self.storyUrl
        }

        self.text = self.text.stringByRemovingHTMLTags().stringByDecodingXMLEntities()
    }

    // MARK: - Helpers

    func parseChildren(withJSON json: [String: AnyObject], level: Int = 0) -> [Item] {
        var stack: [Item] = []

        if let children = json["children"] as? [[String: AnyObject]] {
            for child in children {
                let item = Item(withJSON: child, parseChildren: false)
                item.level = level

                stack.append(item)
                stack.append(contentsOf: self.parseChildren(withJSON: child, level: level + 1))
            }
        }

        return stack
    }

    func setData(fromItem item: Item) {
        self.id = item.id
        self.by = item.by
        self.score = item.score
        self.time = item.time
        self.title = item.title
        self.url = item.url
        self.text = item.text
        self.parent = item.parent
        self.children = item.children
        self.dateAdded = item.dateAdded
        self.descendants = item.descendants
        self.level = item.level
        self.isLoaded = item.isLoaded
    }

    func shareContent() -> [Any] {
        switch self.type {
        case .story:
            return ["\(self.title) \(self.url)"]
        case .comment:
            return [self.text, self.itemWebURL]
        default:
            return []
        }
    }

    func commentsList(level: Int = 0) -> [Item] {
        var stack: [Item] = []

        for child in self.children {
            child.level = level

            stack.append(child)
            stack.append(contentsOf: child.commentsList(level: level + 1))
        }

        return stack
    }

    func storyItem() -> Item {
        let item = Item()
        item.type = .story
        item.id = self.storyId
        item.title = self.storyTitle
        item.text = self.storyText
        item.url = self.storyUrl
        item.isLoaded = false

        return item
    }

    // MARK: - Coder

    required public init?(coder aDecoder: NSCoder) {
        super.init()

        self.type = ItemType.init(rawValue: aDecoder.decodeObject(forKey: "type") as? String ?? self.type.rawValue) ?? self.type
        self.id = aDecoder.decodeInteger(forKey: "id") 
        self.by = aDecoder.decodeObject(forKey: "by") as? String ?? self.by
        self.time = aDecoder.decodeDouble(forKey: "time")
        self.score = aDecoder.decodeInteger(forKey: "score")
        self.title = aDecoder.decodeObject(forKey: "title") as? String ?? self.title
        self.text = aDecoder.decodeObject(forKey: "text") as? String ?? self.text
        self.url = aDecoder.decodeObject(forKey: "url") as? String ?? self.url
        self.parent = aDecoder.decodeInteger(forKey: "parent")
        self.dateAdded = aDecoder.decodeObject(forKey: "dateAdded") as? Date ?? self.dateAdded
        self.descendants = aDecoder.decodeInteger(forKey: "descendants")
        self.children = aDecoder.decodeObject(forKey: "children") as? [Item] ?? self.children
        self.level = aDecoder.decodeInteger(forKey: "level")
        self.isLoaded = aDecoder.decodeBool(forKey: "isLoaded")
        self.storyId = aDecoder.decodeInteger(forKey: "storyId")
        self.storyTitle = aDecoder.decodeObject(forKey: "storyTitle") as? String ?? self.storyTitle
        self.storyText = aDecoder.decodeObject(forKey: "storyText") as? String ?? self.storyText
        self.storyUrl = aDecoder.decodeObject(forKey: "storyUrl") as? String ?? self.storyUrl
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.type.rawValue, forKey: "type")
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.by, forKey: "by")
        aCoder.encode(self.time, forKey: "time")
        aCoder.encode(self.score, forKey: "score")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.text, forKey: "text")
        aCoder.encode(self.url, forKey: "url")
        aCoder.encode(self.parent, forKey: "parent")
        aCoder.encode(self.dateAdded, forKey: "dateAdded")
        aCoder.encode(self.descendants, forKey: "descendants")
        aCoder.encode(self.children, forKey: "children")
        aCoder.encode(self.level, forKey: "level")
        aCoder.encode(self.isLoaded, forKey: "isLoaded")
        aCoder.encode(self.storyId, forKey: "storyId")
        aCoder.encode(self.storyTitle, forKey: "storyTitle")
        aCoder.encode(self.storyText, forKey: "storyText")
        aCoder.encode(self.storyUrl, forKey: "storyUrl")
    }

}
