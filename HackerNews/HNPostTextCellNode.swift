//
//  HNTextCellNode.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 6/24/17.
//  Copyright © 2017 Null. All rights reserved.
//

import AsyncDisplayKit

class HNPostTextCellNode: ASCellNode {

    // MARK: - Properties

    var textNode = TextFieldNode()

    var delegate: ASEditableTextNodeDelegate? {
        set {
            self.textNode.delegate = newValue
        }
        get {
            return self.textNode.delegate
        }
    }

    // MARK: - Inits

    override init() {
        super.init()

        self.automaticallyManagesSubnodes = true

        self.selectionStyle = .none
    }

    // MARK: - Layout

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        let insetContentStack = ASInsetLayoutSpec(
            insets: UIEdgeInsetsMake(HNDimensions.padding,
                                     HNDimensions.padding / 2,
                                     HNDimensions.padding,
                                     HNDimensions.padding / 2
            ),
            child: self.textNode)

        return insetContentStack
    }

}
