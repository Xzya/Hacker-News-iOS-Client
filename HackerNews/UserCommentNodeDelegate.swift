//
//  UserCommentNodeDelegate.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 12/4/16.
//  Copyright © 2016 Null. All rights reserved.
//

import AsyncDisplayKit

@objc protocol UserCommentNodeDelegate {
    @objc optional func userCommentNode(_ userCommentNode: UserCommentNode, didPressLink link: String, withSender sender: ASDisplayNode)
}
