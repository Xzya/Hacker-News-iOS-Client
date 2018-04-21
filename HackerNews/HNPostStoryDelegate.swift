//
//  HNPostStoryDelegate.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 6/5/17.
//  Copyright © 2017 Null. All rights reserved.
//

import AsyncDisplayKit

@objc protocol HNPostStoryDelegate {
    func postStory(didPressSubmitButton button: ASDisplayNode, title: String, url: String, text: String)
    func postStory(didPressCloseButton button: ASDisplayNode)
}
