//
//  AuthDelegate.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/12/16.
//  Copyright © 2016 Null. All rights reserved.
//

import AsyncDisplayKit

@objc protocol AuthNodeDelegate {
    func authNode(didPressSwitchToSignupButton button: ASDisplayNode)
    func authNode(didPressSwitchToLoginButton button: ASDisplayNode)
    func authNode(didPressSwitchToForgotPasswordButton button: ASDisplayNode)
    func authNode(didPressSubmitButton button: ASDisplayNode, username: String, password: String)
    func authNode(didPressCloseButton button: ASDisplayNode)
}
