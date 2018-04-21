//
//  AuthNode.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/12/16.
//  Copyright © 2016 Null. All rights reserved.
//

import AsyncDisplayKit

enum AuthState {
    case login
    case register
}

class AuthNode: ASScrollNode {

    // MARK: - Properties

    var navigationBar = ASDisplayNode()
    var closeButton = ASButtonNode()
    var switchToSignupButton = MiddleButtonNode()
    var switchToLoginButton = MiddleButtonNode()
    var usernameTextField = TextFieldNode()
    var passwordTextField = TextFieldNode()
    var switchToForgotPasswordButton = MiddleButtonNode()
    var submitButton = FullButtonNode()

    weak var delegate: AuthNodeDelegate?

    var password: String = ""

    var state: AuthState = .login

    // MARK: - Inits

    init(state: AuthState) {
        super.init()

        self.state = state

        self.automaticallyManagesSubnodes = true

        // scroll
        self.view.alwaysBounceVertical = true
        self.view.delegate = self

        // close button
        self.closeButton.setAttributedTitle(
            NSAttributedString.init(
                string: IonIconType.ion_close.rawValue,
                attributes: Styles.navigation.icon),
            for: .normal
        )
        self.closeButton.isUserInteractionEnabled = true
        self.closeButton.addTarget(self, action: #selector(self.onCloseButtonPressed), forControlEvents: .touchUpInside)
        self.closeButton.hitTestSlop = UIEdgeInsetsMake(
            -HNDimensions.padding,
            -HNDimensions.padding,
            -HNDimensions.padding,
            -HNDimensions.padding)

        // switch to signup
        self.switchToSignupButton.set(title: "kDontHaveAccount".localized)
        self.switchToSignupButton.isUserInteractionEnabled = true
        self.switchToSignupButton.addTarget(self, action: #selector(self.switchToSignupButtonPressed), forControlEvents: .touchUpInside)

        // switch to login
        self.switchToLoginButton.set(title: "kAlreadyHaveAccount".localized)
        self.switchToLoginButton.isUserInteractionEnabled = true
        self.switchToLoginButton.addTarget(self, action: #selector(self.switchToLoginButtonPressed), forControlEvents: .touchUpInside)
        self.addSubnode(self.switchToLoginButton)

        // username
        self.usernameTextField.set(placeholderText: "kUsernamePlaceholder".localized)
        self.usernameTextField.returnKeyType = .next
        self.usernameTextField.autocorrectionType = .no
        self.usernameTextField.delegate = self
        self.usernameTextField.enablesReturnKeyAutomatically = true
        self.usernameTextField.autocapitalizationType = .none
        self.addSubnode(self.usernameTextField)

        // password
        self.passwordTextField.set(placeholderText: "kPasswordPlaceholder".localized)
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.returnKeyType = .done
        self.passwordTextField.autocorrectionType = .no
        self.passwordTextField.autocapitalizationType = .none
        self.passwordTextField.delegate = self
        self.passwordTextField.enablesReturnKeyAutomatically = true
        self.addSubnode(self.passwordTextField)

        // switch to forgot
        self.switchToForgotPasswordButton.set(title: "kForgotPassword".localized)
        self.switchToForgotPasswordButton.isUserInteractionEnabled = true
        self.switchToForgotPasswordButton.addTarget(self, action: #selector(self.switchToForgotPasswordButtonPressed), forControlEvents: .touchUpInside)
        self.addSubnode(self.switchToForgotPasswordButton)

        // submit
        self.submitButton.set(title: self.state == .login ? "kLoginButton".localized : "kSignupButton".localized)
        self.submitButton.isUserInteractionEnabled = true
        self.submitButton.addTarget(self, action: #selector(self.onSubmitButtonPressed), forControlEvents: .touchUpInside)
        self.addSubnode(self.submitButton)

        self.setupTheme()
    }

    // MARK: - Helpers

    func set(state: AuthState) {
        self.state = state

        self.usernameTextField.attributedText = nil
        self.passwordTextField.attributedText = nil
        self.password = ""

        self.submitButton.set(title: self.state == .login ? "kLoginButton".localized : "kSignupButton".localized)

        self.setNeedsLayout()
    }

    // MARK: - Layout

    override func layout() {
        super.layout()

        self.closeButton.position = CGPoint(x: HNDimensions.padding + self.closeButton.calculatedSize.width / 2, y: 20 + 44 / 2)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        // navigation bar
        self.navigationBar.style.width = .init(unit: .fraction, value: 1)
        self.navigationBar.style.height = .init(unit: .points, value: 64)

        // close button spec
        let closeSpec = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 0,
            justifyContent: .start,
            alignItems: .start,
            children: [self.closeButton])

        // navigation bar spec
        let navSpec = ASOverlayLayoutSpec(
            child: self.navigationBar,
            overlay: closeSpec)
        navSpec.style.height = .init(unit: .points, value: 64)

        // signup
        self.switchToSignupButton.style.alignSelf = .center

        // login
        self.switchToLoginButton.style.alignSelf = .center

        // username
        self.usernameTextField.style.width = .init(unit: .fraction, value: 1)

        // password
        self.passwordTextField.style.width = .init(unit: .fraction, value: 1)

        // forgot password
        self.switchToForgotPasswordButton.style.alignSelf = .center

        // submit button
        self.submitButton.style.width = .init(unit: .fraction, value: 1)
        self.submitButton.contentEdgeInsets = UIEdgeInsetsMake(
            HNDimensions.padding, 0,
            HNDimensions.padding, 0)

        // middle stack
        let middleStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: HNDimensions.padding,
            justifyContent: .start,
            alignItems: .start,
            children: [])
        middleStack.style.width = .init(unit: .fraction, value: 1)

        // different layout for login/register
        if self.state == .login {
            middleStack.children = [self.switchToSignupButton, self.usernameTextField, self.passwordTextField, self.switchToForgotPasswordButton, self.submitButton]
        } else {
            middleStack.children = [self.switchToLoginButton, self.usernameTextField, self.passwordTextField, self.submitButton]
        }

        // inset the middle stack
        let insetStack = ASInsetLayoutSpec(
            insets: UIEdgeInsetsMake(
                HNDimensions.padding,
                HNDimensions.padding,
                HNDimensions.padding,
                HNDimensions.padding),
            child: middleStack)

        // middle stack + navigation
        let mainStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 0,
            justifyContent: .start,
            alignItems: .center,
            children: [navSpec, insetStack])

        return mainStack
    }

    // MARK: - IBActions

    func switchToSignupButtonPressed() {
        self.delegate?.authNode(didPressSwitchToSignupButton: self.switchToSignupButton)
    }

    func switchToLoginButtonPressed() {
        self.delegate?.authNode(didPressSwitchToLoginButton: self.switchToLoginButton)
    }

    func switchToForgotPasswordButtonPressed() {
        self.delegate?.authNode(didPressSwitchToForgotPasswordButton: self.switchToForgotPasswordButton)
    }

    func onSubmitButtonPressed() {
        self.delegate?.authNode(didPressSubmitButton: self.submitButton, username: self.usernameTextField.textView.text ?? "", password: self.password)
    }

    func onCloseButtonPressed() {
        self.delegate?.authNode(didPressCloseButton: self.closeButton)
    }

}

// MARK: - ASEditableTextNodeDelegate

extension AuthNode: ASEditableTextNodeDelegate {

    func editableTextNodeDidUpdateText(_ editableTextNode: ASEditableTextNode) {
        if editableTextNode == self.passwordTextField {
            let selectedRange = editableTextNode.selectedRange
            editableTextNode.textView.text = String.init(repeating: "*", count: self.password.characters.count)
            editableTextNode.selectedRange = selectedRange
        }
    }

    func editableTextNode(_ editableTextNode: ASEditableTextNode, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // if we hit the return key
        if text == "\n" {

            // resign the current text field
            editableTextNode.resignFirstResponder()

            // if the current text field is the username
            if editableTextNode == self.usernameTextField {
                // focus the password field
                self.passwordTextField.becomeFirstResponder()
            }

            // don't append the return
            return false
        }

        // if the current text field is the password
        if editableTextNode == self.passwordTextField {
            // replace the password
            self.password = (self.password as NSString).replacingCharacters(in: range, with: text)
        }

        return true
    }

}

// MARK: - UIScrollViewDelegate

extension AuthNode: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}
