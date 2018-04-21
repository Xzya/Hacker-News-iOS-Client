//
//  StoryDetailNodeDelegate.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/24/16.
//  Copyright © 2016 Null. All rights reserved.
//

import AsyncDisplayKit

@objc protocol StoryDetailNodeDelegate {
    @objc optional func storyDetail(_ storyDetail: StoryDetailNode, didPressPosterButtonWithSender sender: ASDisplayNode)
    @objc optional func storyDetail(_ storyDetail: StoryDetailNode, didPressTitleWithSender sender: ASDisplayNode)
    @objc optional func storyDetail(_ storyDetail: StoryDetailNode, didPressSiteButtonWithSender sender: ASDisplayNode)
    @objc optional func storyDetail(_ storyDetail: StoryDetailNode, didPressLink link: String, withSender sender: ASDisplayNode)
}
