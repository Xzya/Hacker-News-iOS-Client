//
//  HNPostStoryNode.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 6/5/17.
//  Copyright © 2017 Null. All rights reserved.
//

import AsyncDisplayKit

class HNPostStoryNode: ASScrollNode {

    // MARK: - Properties

    var navigationBar = ASDisplayNode()
    var closeButton = ASButtonNode()
    var titleTextField = TextFieldNode()
    var urlTextField = TextFieldNode()
    var textTextField = TextFieldNode()

    weak var delegate: HNPostStoryDelegate?

    // MARK: - Inits

    override init() {
        super.init()

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
            -HNDimensions.padding
        )

        // title
        self.titleTextField.set(placeholderText: "kPostStoryTitlePlaceholder".localized)
        self.titleTextField.returnKeyType = .next
        self.titleTextField.autocorrectionType = .default
        self.titleTextField.delegate = self
        self.titleTextField.enablesReturnKeyAutomatically = false
        self.titleTextField.autocapitalizationType = .sentences

        // url
        self.urlTextField.set(placeholderText: "kPostStoryUrlPlaceholder".localized)
        self.urlTextField.returnKeyType = .next
        self.urlTextField.autocorrectionType = .no
        self.urlTextField.delegate = self
        self.urlTextField.enablesReturnKeyAutomatically = false
        self.urlTextField.autocapitalizationType = .none

        // text
        self.textTextField.set(placeholderText: "kPostStoryTextPlaceholder".localized)
        self.textTextField.returnKeyType = .done
        self.textTextField.autocorrectionType = .default
//        self.textTextField.delegate = self
        self.textTextField.enablesReturnKeyAutomatically = true
        self.textTextField.autocapitalizationType = .sentences

        self.setupTheme()
        self.addNotificationListeners()
    }

    deinit {
        self.removeNotificationListeners()
    }

    // MARK: - Helpers

    func addNotificationListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }

    func removeNotificationListeners() {
        NotificationCenter.default.removeObserver(self)
    }

    func keyboardWillShow() {
        // save reference to current text field

        // if y < current text field

        // set y offset
    }

    func keyboardWillHide() {
        // reset the offset
    }

    // MARK: - Layout

    override func layout() {
        super.layout()

        self.closeButton.position = CGPoint(x: HNDimensions.padding + self.closeButton.calculatedSize.width / 2, y: HNDimensions.navigation.statusBarHeight + HNDimensions.navigation.height / 2)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        // navigation bar
        self.navigationBar.style.width = .init(unit: .fraction, value: 1)
        self.navigationBar.style.height = .init(unit: .points, value: HNDimensions.navigation.statusBarHeight + HNDimensions.navigation.height)

        self.titleTextField.style.flexGrow = 0.1
        self.urlTextField.style.flexGrow = 0.1
        self.textTextField.style.flexGrow = 0.8

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
        navSpec.style.height = .init(unit: .points, value: HNDimensions.navigation.statusBarHeight + HNDimensions.navigation.height)

        // middle stack
        let middleStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: HNDimensions.padding,
            justifyContent: .start,
            alignItems: .stretch,
            children: [
                self.titleTextField,
                self.urlTextField,
                self.textTextField
            ])
        middleStack.style.width = .init(unit: .fraction, value: 1)
        middleStack.style.height = .init(unit: .fraction, value: 1)

        // inset the middle stack
        let insetStack = ASInsetLayoutSpec(
            insets: UIEdgeInsetsMake(
                HNDimensions.padding,
                HNDimensions.padding,
                HNDimensions.padding,
                HNDimensions.padding
            ),
            child: middleStack
        )

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

    func onSubmitButtonPressed() {
//        self.delegate?.postStory(didPressSubmitButton: self.submitButton, title: self.titleTextField.textView.text ?? "", url: self.urlTextField.textView.text ?? "", text: self.textTextField.textView.text ?? "")
    }

    func onCloseButtonPressed() {
        self.delegate?.postStory(didPressCloseButton: self.closeButton)
    }

}

// MARK: - UIScrollViewDelegate

extension HNPostStoryNode: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }

}

// MARK: - ASEditableTextNodeDelegate

extension HNPostStoryNode: ASEditableTextNodeDelegate {

    func editableTextNode(_ editableTextNode: ASEditableTextNode, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // if we hit the return key
        if text == "\n" {

            // resign the current text field
            editableTextNode.resignFirstResponder()

            // if the current text field is the title
            if editableTextNode == self.titleTextField {
                // focus the url
                self.urlTextField.becomeFirstResponder()
            } else if editableTextNode == self.urlTextField {
                // focus the text
                self.textTextField.becomeFirstResponder()
            }

            // don't append the return
            return false
        }

        return true
    }

}
