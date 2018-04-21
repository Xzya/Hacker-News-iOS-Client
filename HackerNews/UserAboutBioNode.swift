//
//  UserAboutBioNode.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/6/16.
//  Copyright © 2016 Null. All rights reserved.
//

import AsyncDisplayKit

class UserAboutBioNode: ASCellNode {

    // MARK: - Properties

    var aboutNode: ASTextNode!

    weak var delegate: UserAboutBioNodeDelegate?

    // MARK: - Inits

    init(withUser user: User) {
        super.init()

        self.selectionStyle = .none

        // about
        self.aboutNode = ASTextNode()
        self.aboutNode.attributedText = NSMutableAttributedString(
            string: user.about,
            attributes: Styles.user.aboutBio).detectLinks()
        self.aboutNode.isUserInteractionEnabled = true
        self.aboutNode.linkAttributeNames = [Constants.kTextLinkAttributeName]
        self.aboutNode.passthroughNonlinkTouches = true
        self.aboutNode.delegate = self
        self.addSubnode(self.aboutNode)

        self.setupTheme()
    }

    // MARK: - Layout

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        let insetStack = ASInsetLayoutSpec(
            insets: UIEdgeInsetsMake(
                HNDimensions.padding / 2,
                HNDimensions.padding,
                HNDimensions.padding / 2,
                HNDimensions.padding),
            child: self.aboutNode)

        return insetStack
    }

}

// MARK: - ASTextNodeDelegate

extension UserAboutBioNode: ASTextNodeDelegate {

    func textNode(_ textNode: ASTextNode, shouldHighlightLinkAttribute attribute: String, value: Any, at point: CGPoint) -> Bool {
        return true
    }

    func textNode(_ textNode: ASTextNode, tappedLinkAttribute attribute: String, value: Any, at point: CGPoint, textRange: NSRange) {
        if let value = value as? URL {
            self.delegate?.userAboutBioNode?(self, didPressLink: value.absoluteString, withSender: textNode)
        }
    }

}
