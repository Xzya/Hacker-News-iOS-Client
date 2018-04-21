//
//  OptionActionNode.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 6/3/17.
//  Copyright © 2017 Null. All rights reserved.
//

import AsyncDisplayKit

/**
 * Full width button with centered text. 
 * Used for buttons like cancel/close in the options select controller.
 */
class HNOptionActionNode: ASCellNode {

    // MARK: - Properties

    var titleNode = ASTextNode()

    // MARK: - Inits

    init(optionType type: OptionType) {
        super.init()

        self.automaticallyManagesSubnodes = true

        // title
        self.titleNode.attributedText = NSAttributedString(
            string: type.title,
            attributes: Styles.options.title
        )
        self.titleNode.style.alignSelf = .center

        self.setupTheme()
    }

    // MARK: - Layout

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        let centered = ASCenterLayoutSpec(
            centeringOptions: .XY,
            sizingOptions: [],
            child: self.titleNode
        )

        let insetTitle = ASInsetLayoutSpec(
            insets: UIEdgeInsetsMake(
                HNDimensions.padding / 1.5,
                HNDimensions.padding,
                HNDimensions.padding / 1.5,
                HNDimensions.padding),
            child: centered)

        return insetTitle
    }

}
