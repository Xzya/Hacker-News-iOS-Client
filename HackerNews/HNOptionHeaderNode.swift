//
//  HNOptionHeaderNode.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 6/4/17.
//  Copyright © 2017 Null. All rights reserved.
//

import AsyncDisplayKit

/**
 * Header node for an option.
 */
class HNOptionHeaderNode: ASCellNode {

    // MARK: - Properties

    var titleNode = ASTextNode()
    var topDividerNode = ASDisplayNode()
    var bottomDividerNode = ASDisplayNode()

    // MARK: - Inits

    init(withTitle title: String) {
        super.init()

        self.automaticallyManagesSubnodes = true

        // title
        self.titleNode.attributedText = NSAttributedString(
            string: title,
            attributes: Styles.options.header
        )
        self.titleNode.style.alignSelf = .start

        self.setupTheme()
    }

    // MARK: - Layout

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        // grow horizontally
        self.topDividerNode.style.flexGrow = 1
        self.bottomDividerNode.style.flexGrow = 1

        // height 1
        self.topDividerNode.style.preferredSize = CGSize(width: 0, height: 1)
        self.bottomDividerNode.style.preferredSize = CGSize(width: 0, height: 1)

        // align the title to the left
        self.titleNode.style.alignSelf = .start

        let insetTitle = ASInsetLayoutSpec(
            insets: UIEdgeInsetsMake(
                HNDimensions.padding / 1.5,
                HNDimensions.padding,
                HNDimensions.padding / 1.5,
                HNDimensions.padding),
            child: self.titleNode)

        let mainStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 0,
            justifyContent: .center,
            alignItems: .stretch,
            children: [self.topDividerNode, insetTitle, self.bottomDividerNode]
        )

        return mainStack
    }

}
