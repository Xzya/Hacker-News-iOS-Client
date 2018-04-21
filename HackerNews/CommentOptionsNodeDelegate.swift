//
//  CommentOptionsNodeDelegate.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/23/16.
//  Copyright © 2016 Null. All rights reserved.
//

import AsyncDisplayKit

@objc protocol CommentOptionsNodeDelegate {
    @objc optional func commentOptions(_ commentOptions: CommentOptionsNode, didPressMoreButtonWithSender sender: ASDisplayNode)
    @objc optional func commentOptions(_ commentOptions: CommentOptionsNode, didPressReplyButtonWithSender sender: ASDisplayNode)
    @objc optional func commentOptions(_ commentOptions: CommentOptionsNode, didPressVoteButtonWithSender sender: ASDisplayNode)
}
