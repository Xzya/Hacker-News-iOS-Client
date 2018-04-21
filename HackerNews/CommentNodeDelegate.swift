//
//  CommentNodeDelegate.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/23/16.
//  Copyright © 2016 Null. All rights reserved.
//

import AsyncDisplayKit

@objc protocol CommentNodeDelegate {
    @objc optional func commentNode(_ commentNode: CommentNode, didPressExpandButtonWithSender sender: ASDisplayNode, expanded: Bool)
    @objc optional func commentNode(_ commentNode: CommentNode, didPressPosterButtonWithSender sender: ASDisplayNode)
    @objc optional func commentNode(_ commentNode: CommentNode, didPressLink link: String, withSender sender: ASDisplayNode)
}
