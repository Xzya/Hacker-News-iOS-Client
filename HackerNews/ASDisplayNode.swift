//
//  ASDisplayNode.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 6/4/17.
//  Copyright © 2017 Null. All rights reserved.
//

import AsyncDisplayKit

extension ASDisplayNode {
    func layoutThatFits(size: CGSize) -> ASLayout {
        return self.layoutThatFits(.init(min: CGSize.zero, max: size))
    }
}
