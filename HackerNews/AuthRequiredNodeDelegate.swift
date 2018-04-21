//
//  AuthRequiredNodeDelegate.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/12/16.
//  Copyright © 2016 Null. All rights reserved.
//

import AsyncDisplayKit

@objc protocol AuthRequiredNodeDelegate {
    func authRequiredNode(didPressLoginButton button: ASDisplayNode)
    func authRequiredNode(didPressSignupButton button: ASDisplayNode)
}
