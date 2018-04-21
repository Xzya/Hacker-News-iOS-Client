//
//  StoryTypeNode.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/22/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class StoryTypeNode: ASCellNode {

    // MARK: - Properties

    var titleNode: ASTextNode!

    // MARK: - Inits

    init(withTitle title: String) {
        super.init()

        // title
        self.titleNode = ASTextNode()
        self.titleNode.attributedText = NSAttributedString(
            string: title,
            attributes: Styles.storyType.title)
        self.addSubnode(self.titleNode)

        self.setupTheme()
    }

    // MARK: - Layout

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(
            insets: UIEdgeInsetsMake(
                HNDimensions.padding / 1.5,
                HNDimensions.padding,
                HNDimensions.padding / 1.5,
                HNDimensions.padding),
            child: self.titleNode)
    }

}
