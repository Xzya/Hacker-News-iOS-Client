//
//  SettingsDropdownNode.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/30/16.
//  Copyright © 2016 Null. All rights reserved.
//

import AsyncDisplayKit

class SettingsNode: ASCellNode {

    // MARK: - Properties

    var iconNode = ASTextNode()
    var titleNode = ASTextNode()
    var selectedNode = ASTextNode()
    var rightIconNode = ASTextNode()

    var nodeType: SettingsNodeType = .action

    // MARK: - Inits

    init(dropdownNodeWithType type: OptionType, selected: OptionType) {
        super.init()

        self.nodeType = .dropdown

        self.commonInit(optionType: type)

        // selected title
        self.selectedNode.attributedText = NSAttributedString(
            string: selected.title,
            attributes: Styles.settings.selectedTitle)

        // right icon
        self.rightIconNode.attributedText = NSAttributedString(
            string: IonIconType.ion_chevron_down.rawValue,
            attributes: Styles.settings.rightIcon)
    }

    init(actionNodeWithType type: OptionType) {
        super.init()

        self.nodeType = .action

        self.commonInit(optionType: type)
    }

    init(openNodeWithType type: OptionType) {
        super.init()

        self.nodeType = .open

        self.commonInit(optionType: type)

        // right icon
        self.rightIconNode.attributedText = NSAttributedString(
            string: IonIconType.ion_chevron_right.rawValue,
            attributes: Styles.settings.rightIcon)
    }

    func commonInit(optionType type: OptionType) {
        self.automaticallyManagesSubnodes = true

        // icon
        self.iconNode.attributedText = NSAttributedString(
            string: type.icon.rawValue,
            attributes: Styles.settings.icon)

        // title
        self.titleNode.attributedText = NSAttributedString(
            string: type.title,
            attributes: Styles.settings.title)

        self.setupTheme()
    }

    // MARK: - Layout

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        switch self.nodeType {
        case .dropdown:
            let leftStack = ASStackLayoutSpec(
                direction: .horizontal,
                spacing: HNDimensions.padding / 2,
                justifyContent: .start,
                alignItems: .center,
                children: [self.iconNode, self.titleNode])

            let rightStack = ASStackLayoutSpec(
                direction: .horizontal,
                spacing: HNDimensions.padding / 2,
                justifyContent: .end,
                alignItems: .center,
                children: [self.selectedNode, self.rightIconNode])

            let spacer = ASLayoutSpec()
            spacer.style.flexGrow = 1
            spacer.style.flexShrink = 1

            let mainStack = ASStackLayoutSpec(
                direction: .horizontal,
                spacing: 0,
                justifyContent: .start,
                alignItems: .center, children: [leftStack, spacer, rightStack])

            let insetTitle = ASInsetLayoutSpec(
                insets: UIEdgeInsetsMake(
                    HNDimensions.padding / 1.5,
                    HNDimensions.padding,
                    HNDimensions.padding / 1.5,
                    HNDimensions.padding),
                child: mainStack)
            
            return insetTitle

        case .action:
            let leftStack = ASStackLayoutSpec(
                direction: .horizontal,
                spacing: HNDimensions.padding / 2,
                justifyContent: .start,
                alignItems: .center,
                children: [self.iconNode, self.titleNode])

            let insetTitle = ASInsetLayoutSpec(
                insets: UIEdgeInsetsMake(
                    HNDimensions.padding / 1.5,
                    HNDimensions.padding,
                    HNDimensions.padding / 1.5,
                    HNDimensions.padding),
                child: leftStack)

            return insetTitle

        case .open:
            let leftStack = ASStackLayoutSpec(
                direction: .horizontal,
                spacing: HNDimensions.padding / 2,
                justifyContent: .start,
                alignItems: .center,
                children: [self.iconNode, self.titleNode])

            let rightStack = ASStackLayoutSpec(
                direction: .horizontal,
                spacing: HNDimensions.padding / 2,
                justifyContent: .end,
                alignItems: .center,
                children: [self.rightIconNode])

            let spacer = ASLayoutSpec()
            spacer.style.flexGrow = 1
            spacer.style.flexShrink = 1

            let mainStack = ASStackLayoutSpec(
                direction: .horizontal,
                spacing: 0,
                justifyContent: .start,
                alignItems: .center, children: [leftStack, spacer, rightStack])

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

}
