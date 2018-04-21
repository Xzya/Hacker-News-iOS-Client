//
//  OptionSelectNode.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/23/16.
//  Copyright © 2016 Null. All rights reserved.
//

import AsyncDisplayKit

class OptionSelectNode: ASCellNode {

    // MARK: - Properties

    var iconNode: ASTextNode!
    var titleNode: ASTextNode!

    // MARK: - Inits

    init(optionType type: OptionType, selected: Bool = false) {
        super.init()

        // icon
        self.iconNode = ASTextNode()
        self.iconNode.attributedText = IonIcon.textIcon(
            type: type.icon,
            color: selected ? Styles.options.highlightedIcon : Styles.options.icon
        )
        self.addSubnode(self.iconNode)

        // title
        self.titleNode = ASTextNode()
        self.titleNode.attributedText = NSAttributedString(
            string: type.title,
            attributes: Styles.options.title
        )
        self.addSubnode(self.titleNode)

        self.setupTheme()
    }

    // MARK: - Layout

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        let mainStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: HNDimensions.padding,
            justifyContent: .start,
            alignItems: .center,
            children: [self.iconNode, self.titleNode])

        let insetTitle = ASInsetLayoutSpec(
            insets: UIEdgeInsetsMake(
                HNDimensions.padding / 1.5,
                HNDimensions.padding,
                HNDimensions.padding / 1.5,
                HNDimensions.padding),
            child: mainStack)

        return insetTitle
    }

}
