//
//  UserCommentNode.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/6/16.
//  Copyright © 2016 Null. All rights reserved.
//

import AsyncDisplayKit

class UserCommentNode: ASCellNode {

    // MARK: - Properties

    var posterNode = ASTextNode()
    var titleNode = ASTextNode()
    var textNode = ASTextNode()

    weak var delegate: UserCommentNodeDelegate?

    // MARK: - Inits

    init(withItem item: Item) {
        super.init()

        self.automaticallyManagesSubnodes = true
        self.selectionStyle = .none

        // poster
        self.posterNode.attributedText = NSAttributedString(
            string: "\(item.by) • \(NSDate.init(timeIntervalSince1970: item.time).timeAgo() ?? "")",
            attributes: Styles.story.poster
        )
        self.posterNode.truncationMode = .byTruncatingTail
        self.posterNode.maximumNumberOfLines = 1
        self.posterNode.style.flexShrink = 1

        // title
        self.titleNode.attributedText = NSAttributedString(
            string: item.storyTitle,
            attributes: Styles.storyDetails.title
        )

        // text
        self.textNode.attributedText = NSMutableAttributedString(
            string: item.text,
            attributes: Styles.storyDetails.text).detectLinks()
        self.textNode.isUserInteractionEnabled = true
        self.textNode.linkAttributeNames = [Constants.kTextLinkAttributeName]
        self.textNode.passthroughNonlinkTouches = true
        self.textNode.delegate = self

        self.setupTheme()
    }

    // MARK: - Layout

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        let mainStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: HNDimensions.padding / 2,
            justifyContent: .start,
            alignItems: .start,
            children: [self.posterNode, self.titleNode, self.textNode])

        let insetStack = ASInsetLayoutSpec(
            insets: UIEdgeInsetsMake(
                HNDimensions.padding / 2,
                HNDimensions.padding,
                HNDimensions.padding / 2,
                HNDimensions.padding),
            child: mainStack)

        return insetStack
    }

}

// MARK: - ASTextNodeDelegate

extension UserCommentNode: ASTextNodeDelegate {

    func textNode(_ textNode: ASTextNode, shouldHighlightLinkAttribute attribute: String, value: Any, at point: CGPoint) -> Bool {
        return true
    }

    func textNode(_ textNode: ASTextNode, tappedLinkAttribute attribute: String, value: Any, at point: CGPoint, textRange: NSRange) {
        if let value = value as? URL {
            self.delegate?.userCommentNode?(self, didPressLink: value.absoluteString, withSender: textNode)
        }
    }

}
