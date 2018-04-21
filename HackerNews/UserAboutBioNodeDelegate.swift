//
//  UserAboutBioNodeDelegate.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 12/4/16.
//  Copyright © 2016 Null. All rights reserved.
//

import AsyncDisplayKit

@objc protocol UserAboutBioNodeDelegate {
    @objc optional func userAboutBioNode(_ userAboutBioNode: UserAboutBioNode, didPressLink link: String, withSender sender: ASDisplayNode)
}
