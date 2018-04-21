//
//  CommentNode.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/23/16.
//  Copyright © 2016 Null. All rights reserved.
//

import AsyncDisplayKit

class CommentNode: ASCellNode {

    // MARK: - Properties

    var expandNode: ASButtonNode!
    var posterNode: ASButtonNode!
    var containerNode: ASDisplayNode!
    var textNode: ASTextNode!

    var item: Item = Item()

    weak var delegate: CommentNodeDelegate?

    var expanded: Bool = true
    var parentCollapsed: Bool = false
    var deleted: Bool = false

    // MARK: - Inits

    init(withItem item: Item, delegate: CommentNodeDelegate? = nil) {
        super.init()

        self.item = item
        self.delegate = delegate
        self.deleted = item.type == .none
        self.expanded = !self.deleted

        // Container
        self.containerNode = ASDisplayNode()
        self.addSubnode(self.containerNode)

        // Expand button
        self.expandNode = ASButtonNode()
        self.setupExpandButton()
        self.expandNode.isUserInteractionEnabled = true
        self.expandNode.addTarget(self, action: #selector(self.onExpandButtonPressed(_:)), forControlEvents: .touchUpInside)
        self.addSubnode(self.expandNode)

        // Poster button
        self.posterNode = ASButtonNode()
        self.posterNode.setAttributedTitle(
            NSAttributedString(
                string: !self.deleted
                    ? " \(item.by) • \(NSDate.init(timeIntervalSince1970: item.time).timeAgo() ?? "")"
                    : " Deleted",
                attributes: Styles.story.poster),
            for: .normal
        )
        self.posterNode.isUserInteractionEnabled = true
        self.posterNode.addTarget(self, action: #selector(self.onPosterButtonPressed(_:)), forControlEvents: .touchUpInside)
        self.addSubnode(self.posterNode)

        // only add the other nodes if the comment is not deleted
        self.textNode = ASTextNode()
        if item.type != .none {
            // Text
            self.textNode.attributedText = NSMutableAttributedString(
                string: item.text,
                attributes: Styles.comment.text).detectLinks()
            self.textNode.isUserInteractionEnabled = true
            self.textNode.linkAttributeNames = [Constants.kTextLinkAttributeName]
            self.textNode.passthroughNonlinkTouches = true
            self.textNode.delegate = self
            self.addSubnode(self.textNode)
        }

        self.setupTheme()
    }

    // MARK: - Helpers

    func setupExpandButton() {
        self.expandNode.setAttributedTitle(
            self.expanded
                ? IonIcon.icon(type: .ion_android_arrow_dropdown_circle, ofSize: FontManager.currentFont.textSize)
                : IonIcon.icon(type: .ion_android_arrow_dropright_circle, ofSize: FontManager.currentFont.textSize),
            for: .normal
        )
    }

    func setParentCollapsed() {
        self.parentCollapsed = true
        self.setNeedsLayout()
    }

    func setParentExpanded() {
        self.parentCollapsed = false
        self.setNeedsLayout()
    }

    func setCollapsed() {
        if !self.deleted {
            self.expanded = false
            self.setupExpandButton()
            self.setNeedsLayout()
        }
    }

    func setExpanded() {
        if !self.deleted {
            self.expanded = true
            self.setupExpandButton()
            self.setNeedsLayout()
        }
    }

    // MARK: - Layout

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        // if the parent is collapsed
        if self.parentCollapsed {
            // don't show anything
            return ASLayoutSpec()
        }

        // expand + poster
        let headerStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 0,
            justifyContent: .start,
            alignItems: .center,
            children: [self.expandNode, self.posterNode])

        // header stack + text
        var contentChildren: [ASLayoutElement] = [headerStack]
        if self.expanded {
            contentChildren.append(self.textNode)
        }
        let contentStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: HNDimensions.padding / 2,
            justifyContent: .center,
            alignItems: .start,
            children: contentChildren)

        let insetContentStack = ASInsetLayoutSpec(
            insets: UIEdgeInsetsMake(HNDimensions.padding / 4,
                                     HNDimensions.padding + CGFloat(self.item.level) * HNDimensions.padding,
                                     HNDimensions.padding / 4,
                                     HNDimensions.padding),
            child: contentStack)

        let containerStack = ASInsetLayoutSpec(
            insets: UIEdgeInsetsMake(0,
                                     HNDimensions.padding + CGFloat(self.item.level) * HNDimensions.padding,
                                     0,
                                     0),
            child: self.containerNode)

        let mainStack = ASBackgroundLayoutSpec(child: insetContentStack, background: containerStack)

        return mainStack
    }

    // MARK: - IBActions

    func onExpandButtonPressed(_ sender: ASDisplayNode) {
        if !self.deleted {
            self.expanded = !self.expanded
            self.setupExpandButton()
            self.setNeedsLayout()

            self.delegate?.commentNode?(self, didPressExpandButtonWithSender: sender, expanded: self.expanded)
        }
    }

    func onPosterButtonPressed(_ sender: ASDisplayNode) {
        if !self.deleted {
            self.delegate?.commentNode?(self, didPressPosterButtonWithSender: sender)
        }
    }

}

// MARK: - ASTextNodeDelegate

extension CommentNode: ASTextNodeDelegate {

    func textNode(_ textNode: ASTextNode, shouldHighlightLinkAttribute attribute: String, value: Any, at point: CGPoint) -> Bool {
        return true
    }

    func textNode(_ textNode: ASTextNode, tappedLinkAttribute attribute: String, value: Any, at point: CGPoint, textRange: NSRange) {
        if let value = value as? URL {
            self.delegate?.commentNode?(self, didPressLink: value.absoluteString, withSender: textNode)
        }
    }
    
}
