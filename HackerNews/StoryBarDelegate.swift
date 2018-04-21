//
//  StoryBarDelegate.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/22/16.
//  Copyright © 2016 Null. All rights reserved.
//

import AsyncDisplayKit

@objc protocol StoryBarDelegate {
    @objc optional func storyBar(_ storyBar: StoryBarNode, didPressShareButtonWithSender sender: ASDisplayNode)
    @objc optional func storyBar(_ storyBar: StoryBarNode, didPressCommentsButtonWithSender sender: ASDisplayNode)
    @objc optional func storyBar(_ storyBar: StoryBarNode, didPressVoteButtonWithSender sender: ASDisplayNode)
}
