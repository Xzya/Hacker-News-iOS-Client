//
//  StoryNodeDelegate.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/22/16.
//  Copyright © 2016 Null. All rights reserved.
//

import AsyncDisplayKit

@objc protocol StoryNodeDelegate {
    @objc optional func storyNode(_ storyNode: StoryNode, didPressOnPosterButton sender: ASDisplayNode)
}
