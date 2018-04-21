//
//  AuthNeededNode.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/12/16.
//  Copyright © 2016 Null. All rights reserved.
//

import AsyncDisplayKit

class AuthRequiredNode: ASDisplayNode {

    // MARK: - Properties

    var titleTextNode = ASTextNode()
    var loginButton = FullButtonNode()
    var signupButton = FullButtonNode()

    weak var delegate: AuthRequiredNodeDelegate?

    // MARK: - Inits

    override init() {
        super.init()

        self.automaticallyManagesSubnodes = true

        // title
        self.titleTextNode.attributedText = NSAttributedString(
            string: "kAuthRequiredTitle".localized,
            attributes: Styles.auth.title
        )

        // login
        self.loginButton.set(title: "kLoginButton".localized)
        self.loginButton.isUserInteractionEnabled = true
        self.loginButton.addTarget(self, action: #selector(self.loginButtonPressed), forControlEvents: .touchUpInside)

        // signup
        self.signupButton.set(title: "kSignupButton".localized)
        self.signupButton.isUserInteractionEnabled = true
        self.signupButton.addTarget(self, action: #selector(self.signupButtonPressed), forControlEvents: .touchUpInside)

        self.setupTheme()
    }

    // MARK: - Layout

    override func layout() {
        super.layout()

        self.titleTextNode.position = CGPoint(x: self.calculatedSize.width / 2, y: self.calculatedSize.height / 2 - self.loginButton.calculatedSize.height / 2)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        let bottomStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: HNDimensions.padding / 2,
            justifyContent: .spaceBetween,
            alignItems: .center,
            children: [self.loginButton, self.signupButton])
        bottomStack.style.width = .init(unit: .fraction, value: 1)

        self.loginButton.style.flexGrow = 0.5
        self.signupButton.style.flexGrow = 0.5

        self.loginButton.contentEdgeInsets = UIEdgeInsetsMake(
            HNDimensions.padding, 0,
            HNDimensions.padding, 0)
        self.signupButton.contentEdgeInsets = UIEdgeInsetsMake(
            HNDimensions.padding, 0,
            HNDimensions.padding, 0)

        let titleSpec = ASCenterLayoutSpec(
            horizontalPosition: .center,
            verticalPosition: .center,
            sizingOption: .minimumSize,
            child: self.titleTextNode)

        let mainSpec = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 0,
            justifyContent: .end,
            alignItems: .center,
            children: [titleSpec, bottomStack])

        let insetSpec = ASInsetLayoutSpec(
            insets: UIEdgeInsetsMake(
                HNDimensions.padding,
                HNDimensions.padding,
                HNDimensions.padding,
                HNDimensions.padding),
            child: mainSpec)

        return insetSpec
    }

    // MARK: - IBActions

    func loginButtonPressed() {
        self.delegate?.authRequiredNode(didPressLoginButton: self.loginButton)
    }

    func signupButtonPressed() {
        self.delegate?.authRequiredNode(didPressSignupButton: self.signupButton)
    }

}
