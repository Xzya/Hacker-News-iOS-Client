//
//  HNDimensions.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 6/2/17.
//  Copyright © 2017 Null. All rights reserved.
//

import UIKit

/**
 * HNDimensions holds the default dimensions for the nodes.
 */
class HNDimensions {

    /**
     * Comments dimensions
     */
    open class comments {

        /**
         * Left padding per comment level (depth)
         */
        static let paddingPerLevel: CGFloat = 16

    }

    /**
     * Item bar
     */
    open class itemBar {

        /**
         * Item bar height
         */
        static let height: CGFloat = 40

        /**
         * Item bar divider height
         */
        static let dividerHeight: CGFloat = 16

    }

    /**
     * Navigation bar (in auth and post story/comment)
     */
    open class navigation {

        /**
         * Navigation bar height
         */
        static let height: CGFloat = 44

        /**
         * Status bar height
         */
        static let statusBarHeight: CGFloat = 20

    }

    /**
     * Default padding
     */
    static let padding: CGFloat = 16

}
