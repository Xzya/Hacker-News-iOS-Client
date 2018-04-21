//
//  UserAboutNode.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/6/16.
//  Copyright © 2016 Null. All rights reserved.
//

import AsyncDisplayKit

class UserAboutNode: ASCellNode {

    // MARK: - Properties

    var karmaLabelNode: ASTextNode!
    var karmaNode: ASTextNode!
    var createdLabelNode: ASTextNode!
    var createdNode: ASTextNode!

    // MARK: - Inits

    init(withUser user: User) {
        super.init()

        self.selectionStyle = .none

        // karma label
        self.karmaLabelNode = ASTextNode()
        self.karmaLabelNode.attributedText = NSAttributedString(
            string: "KARMA",
            attributes: Styles.user.aboutLabel)
        self.addSubnode(self.karmaLabelNode)

        // karma
        self.karmaNode = ASTextNode()
        self.karmaNode.attributedText = NSAttributedString(
            string: "\(user.karma)",
            attributes: Styles.user.aboutValue)
        self.addSubnode(self.karmaNode)

        // created label
        self.createdLabelNode = ASTextNode()
        self.createdLabelNode.attributedText = NSAttributedString(
            string: "MEMBER SINCE",
            attributes: Styles.user.aboutLabel)
        self.addSubnode(self.createdLabelNode)

        // created
        self.createdNode = ASTextNode()
        self.createdNode.attributedText = NSAttributedString(
            string: "\(NSDate.init(timeIntervalSince1970: user.created).timeAgo() ?? "")",
            attributes: Styles.user.aboutValue)
        self.addSubnode(self.createdNode)

        self.setupTheme()
    }

    // MARK: - Layout

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        let karmaStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: HNDimensions.padding / 4,
            justifyContent: .start,
            alignItems: .center,
            children: [self.karmaLabelNode, self.karmaNode])

        let createdStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: HNDimensions.padding / 4,
            justifyContent: .start,
            alignItems: .center,
            children: [self.createdLabelNode, self.createdNode])

        let mainStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 0,
            justifyContent: .spaceBetween,
            alignItems: .center,
            children: [karmaStack, createdStack])

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
