//
//  BackgroundDividerNode.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 12/4/16.
//  Copyright © 2016 Null. All rights reserved.
//

import AsyncDisplayKit

class BackgroundDividerNode: ASDisplayNode {

    // MARK: - Properties

    var dividers: [ASDisplayNode] = []

    var level: Int = 0

    // MARK: - Lifecycle

    init(level: Int) {
        super.init()

        self.level = level
    }

    // MARK: - Helpers

    func createRequiredDividers() {
        while self.dividers.count <= self.level {
            let node = ASDisplayNode()
            self.addSubnode(node)
            self.dividers.append(node)
        }
    }

    func arrangeDividers() {
        for i in 0..<self.dividers.count {
            self.dividers[i].frame = CGRect(
                x: CGFloat(i) * HNDimensions.comments.paddingPerLevel,
                y: 0,
                width: 1,
                height: self.calculatedSize.height
            )
        }
    }

    // MARK: - Layout

    override func layout() {
        super.layout()

        self.createRequiredDividers()
        self.arrangeDividers()
        self.setupTheme()
    }

}
