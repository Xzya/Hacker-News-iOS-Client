//
//  HNPostViewController.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 6/24/17.
//  Copyright © 2017 Null. All rights reserved.
//

import AsyncDisplayKit

class HNPostStoryController: HNPostViewController {

    // MARK: - IBOutlets

    var titleNode = HNPostTextCellNode()
    var urlNode = HNPostTextCellNode()
    var textNode = HNPostTextCellNode()

    // MARK: - Properties

    var currentTextNode: HNPostTextCellNode?

    var postTitle: String = ""
    var postURL: String = ""
    var postText: String = ""

    var keyboardSize: CGSize = CGSize.zero

    // MARK: - Setup Helpers

    override func setup() {
        super.setup()

        self.setupNodes()

        self.title = "Post Story"
    }

    func setupNodes() {
        self.titleNode.delegate = self
        self.urlNode.delegate = self
        self.textNode.delegate = self

//        self.titleNode.textNode.set(placeholderText: "Title")
        self.titleNode.textNode.returnKeyType = .next
        self.titleNode.textNode.autocorrectionType = .default
        self.titleNode.textNode.enablesReturnKeyAutomatically = false
        self.titleNode.textNode.autocapitalizationType = .sentences
        self.titleNode.textNode.set(placeholderText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.")

        self.urlNode.textNode.set(placeholderText: "URL")
        self.urlNode.textNode.returnKeyType = .next
        self.urlNode.textNode.autocorrectionType = .no
        self.urlNode.textNode.enablesReturnKeyAutomatically = false
        self.urlNode.textNode.autocapitalizationType = .none

//        self.textNode.textNode.set(placeholderText: "Text")
        self.textNode.textNode.returnKeyType = .default
        self.textNode.textNode.autocorrectionType = .default
        self.textNode.textNode.enablesReturnKeyAutomatically = true
        self.textNode.textNode.autocapitalizationType = .sentences
        self.textNode.textNode.set(placeholderText: "Donec sed dolor vitae turpis pulvinar porta sit amet ut metus. Quisque varius, turpis eu laoreet sollicitudin, urna lorem efficitur metus, vitae finibus odio quam tempus sapien. Vivamus lacinia, dolor non auctor bibendum, ipsum eros semper massa, ut consequat mi neque quis arcu. Praesent scelerisque id nisi facilisis auctor. Cras vitae orci vehicula, fermentum purus ac, vulputate leo. Vivamus mattis congue gravida.")
    }

    // MARK: - Helpers

    func validateData(title: String, url: String, text: String) -> Bool {

        // title must not be empty
        if title.characters.count < 1 {
            AlertBuilder()
                .set(message: "kErrorEmptyTitle".localized)
                .add(actionWithTitle: "Ok")
                .present(sender: self)

            return false
        }

        // we can't have both an url and a post text
        if url.characters.count > 0 && text.characters.count > 0 {
            AlertBuilder()
                .set(message: "kErrorUrlAndText".localized)
                .add(actionWithTitle: "Ok")
                .present(sender: self)

            return false
        }

        // we must have an url or a title
        if url.characters.count == 0 && text.characters.count == 0 {
            AlertBuilder()
                .set(message: "kErrorEmptyUrlAndText".localized)
                .add(actionWithTitle: "Ok")
                .present(sender: self)

            return false
        }

        // validate url
        if !url.isValidUrl() {
            AlertBuilder()
                .set(message: "kErrorInvalidUrl".localized)
                .add(actionWithTitle: "Ok")
                .present(sender: self)

            return false
        }

        return true
    }

    override func onPostButtonPressed() {
        // make sure the data is valid
        if self.validateData(title: self.postTitle, url: self.postURL, text: self.postText) {

//            // show the loader
//            self.showLoader()
//
//            // post the story
//            HNAPI.postStory(title: title, url: url, text: text)
//                .then { Void -> Void in
//
//                    // TODO: - Redirect to story? Do we get this in the response or headers?
//                    self.close()
//
//                }.always {
//                    self.hideLoader()
//                }.catch { error in
//                    AlertBuilder().set(title: "Error")
//                        .set(message: error.localizedDescription)
//                        .add(actionWithTitle: "OK")
//                        .present(sender: self)
//            }
//            
        }
    }

    override func onKeyboardDidShow(notification: Notification) {
        if let info = notification.userInfo {
            if let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? CGRect)?.size {
                self.keyboardSize = keyboardSize
                let contentInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)

                DispatchQueue.main.async {
                    self.tableView.view.contentInset = contentInsets
                    self.tableView.view.scrollIndicatorInsets = contentInsets

                    self.adjustTableScrollForKeyboard()
                }
            }
        }
    }

    override func onKeyboardWillHide(notification: Notification) {
        DispatchQueue.main.async {
            self.tableView.view.contentInset = UIEdgeInsets.zero
            self.tableView.view.scrollIndicatorInsets = UIEdgeInsets.zero
            self.keyboardSize = CGSize.zero
        }
    }

    func adjustTableScrollForKeyboard() {
        if let indexPath = self.currentTextNode?.indexPath {
            let cellRect = self.tableView.rectForRow(at: indexPath)
            let currentNodeRect = self.tableView.view.convert(cellRect, to: self.view)

            // If active text field is hidden by keyboard, scroll it so it's visible
//            if let currentNodeOrigin = self.currentTextNode?.convert(CGPoint.zero, to: self.tableView) {
                var rect = self.view.frame
                rect.size.height -= keyboardSize.height

            if !rect.contains(CGPoint(x: currentNodeRect.origin.x, y: currentNodeRect.origin.y + currentNodeRect.height)) {
                    let scrollPoint = CGPoint(x: 0, y: (currentNodeRect.origin.y + currentNodeRect.height) - self.keyboardSize.height)
                    self.tableView.view.setContentOffset(scrollPoint, animated: true)
                }
//            }
        }
    }

}

// MARK: - ASTableDataSource, ASTableDelegate

enum PostStoryRowType: Int {
    case title = 0
    case url = 1
    case text = 2

    static var count: Int {
        return 3
    }
}

extension HNPostStoryController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostStoryRowType.count
    }

    override func tableView(_ tableView: ASTableView, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {

        switch indexPath.row {
        case PostStoryRowType.title.rawValue:

            return {
                return self.titleNode
            }

        case PostStoryRowType.url.rawValue:

            return {
                return self.urlNode
            }

        case PostStoryRowType.text.rawValue:

            return {
                return self.textNode
            }

        default:
            assertionFailure("Invalid row.")
        }

        return {ASCellNode()}
    }

    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }

}

// MARK: - ASEditableTextNodeDelegate

extension HNPostStoryController: ASEditableTextNodeDelegate {

    func editableTextNodeDidBeginEditing(_ editableTextNode: ASEditableTextNode) {
        if let parent = editableTextNode.supernode as? HNPostTextCellNode {
            self.currentTextNode = parent
        }
    }

    func editableTextNodeDidFinishEditing(_ editableTextNode: ASEditableTextNode) {
        self.currentTextNode = nil
    }

    func editableTextNode(_ editableTextNode: ASEditableTextNode, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // if we hit the return key
        if text == "\n" {

            // check which text field it is
            if let textNode = editableTextNode as? TextFieldNode {
                switch textNode {
                case self.titleNode.textNode:

                    // resign the current text field
                    editableTextNode.resignFirstResponder()

                    // focus the url
                    self.urlNode.textNode.becomeFirstResponder()

                    return false

                case self.urlNode.textNode:

                    // resign the current text field
                    editableTextNode.resignFirstResponder()

                    // focus the text
                    self.textNode.textNode.becomeFirstResponder()

                    return false

                case self.textNode.textNode:

                    self.adjustTableScrollForKeyboard()

                    return true

                default: break
                }
            }

        }

        return true
    }

    func editableTextNodeDidUpdateText(_ editableTextNode: ASEditableTextNode) {
        editableTextNode.setNeedsLayout()

        if let textNode = editableTextNode as? TextFieldNode {
            switch textNode {
            case self.titleNode.textNode:
                self.postTitle = textNode.attributedText?.string ?? ""

            case self.urlNode.textNode:
                self.postURL = textNode.attributedText?.string ?? ""

            case self.textNode.textNode:
                self.postText = textNode.attributedText?.string ?? ""

            default: break
            }
        }
    }
    
}
