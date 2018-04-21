//
//  LoginViewController.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/29/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class AuthViewController: BaseViewController {

    // MARK: - IBOutlets

    var authNode: AuthNode!

    // MARK: - Properties

    var state: AuthState = .login {
        didSet {
            self.authNode.set(state: self.state)
            self.authNode.usernameTextField.becomeFirstResponder()

            self.title = self.state == .login ? "Login" : "Register"
        }
    }

    // MARK: - Lifecycle

    init(state: AuthState) {
        self.authNode = AuthNode(state: .login)

        self.state = state

        super.init(node: authNode)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
    }

    // MARK: - Setup Helpers

    func setup() {
        self.setupTheme()
        self.setupAuthNode()
        self.setupNavigationItem()

        let state = self.state
        self.state = state
    }

    func setupAuthNode() {
        self.authNode.delegate = self
        self.authNode.frame = self.view.bounds
        self.authNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    func setupNavigationItem() {
        self.navigationItem.set(leftButtonIcon: .ion_close, target: self, action: #selector(self.close))
    }

    // MARK: - Helpers

    func validateLogin(username: String, password: String) -> Bool {
        // username must be between 2 and 15 characters
        if username.characters.count < 2 {
            return false
        }
        if username.characters.count > 15 {
            return false
        }
        // username can only contain text, digits, underscore and dashes

        // password must be > 8 characters
        if password.characters.count < 8 {
            return false
        }
        return true
    }

    func close() {
        self.dismiss(animated: true, completion: nil)
    }

}

// MARK: - AuthNodeDelegate

extension AuthViewController: AuthNodeDelegate {

    func authNode(didPressSwitchToSignupButton button: ASDisplayNode) {
        self.state = .register
    }

    func authNode(didPressSwitchToLoginButton button: ASDisplayNode) {
        self.state = .login
    }

    func authNode(didPressSwitchToForgotPasswordButton button: ASDisplayNode) {
        Utils.openURL(urlString: Constants.kForgotPasswordURL)
    }

    func authNode(didPressSubmitButton button: ASDisplayNode, username: String, password: String) {

        if self.validateLogin(username: username, password: password) {
            self.showLoader()

            switch self.state {
            case .login:

                HNAPI.login(username: username, password: password)
                    .then { Void -> Void in

                        User.sharedInstance = User(username: username)
                        ItemProvider.set(currentUser: User.sharedInstance)

                        NotificationCenter.default.post(Constants.kLoginNotification)

                        self.close()

                    }.always {
                        self.hideLoader()
                    }.catch { error in
                        AlertBuilder().set(title: "Error")
                            .set(message: error.localizedDescription)
                            .add(actionWithTitle: "OK")
                            .present(sender: self)
                }

            case .register:

                HNAPI.register(username: username, password: password)
                    .then { result -> Void in

                        if result.matches(for: "captcha").count > 0 {
                            self.state = .login

                            AlertBuilder()
                                .set(message: "kRegisterCapcha".localized)
                                .add(actionWithTitle: "OK", handler: { _ in
                                    Utils.openURL(urlString: Constants.kLoginURL)
                                })
                                .present(sender: self)

                            return;
                        }

                        User.sharedInstance = User(username: username)
                        self.close()

                    }.always {
                        self.hideLoader()
                    }.catch { error in
                        AlertBuilder().set(title: "Error")
                            .set(message: error.localizedDescription)
                            .add(actionWithTitle: "OK")
                            .present(sender: self)
                }

            }

        } else {
            AlertBuilder().set(title: "Error")
                .set(message: "kInvalidLogin".localized)
                .add(actionWithTitle: "OK")
                .present(sender: self)
        }
    }

    func authNode(didPressCloseButton button: ASDisplayNode) {
        self.dismiss(animated: true, completion: nil)
    }

}
