//
//  OptionSelectView.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/14/16.
//  Copyright © 2016 Null. All rights reserved.
//

import AsyncDisplayKit

class OptionSelectView: ASDisplayNode {

    // MARK: - Properties

    var tableView = OptionSelectTableView()

    // MARK: - Inits

    override init() {
        super.init()

        self.automaticallyManagesSubnodes = true
    }

    // MARK: - Layout

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        self.style.width = .init(unit: .fraction, value: 1)
        self.style.height = .init(unit: .fraction, value: 1)

        let insetStack = ASInsetLayoutSpec(
            insets: UIEdgeInsetsMake(
                HNDimensions.padding / 2 + 20,
                HNDimensions.padding / 2,
                HNDimensions.padding / 2,
                HNDimensions.padding / 2),
            child: self.tableView)

        return insetStack
    }

}
