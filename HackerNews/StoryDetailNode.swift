//
//  StoryDetailNode.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/23/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import NSDate_TimeAgo

class StoryDetailNode: ASCellNode {

    // MARK: - Properties

    var posterNode: ASButtonNode!
    var siteNode: ASButtonNode!
    var titleNode: ASTextNode!
    var textNode: ASTextNode!
    var dividerNode: ASDisplayNode!

    weak var delegate: StoryDetailNodeDelegate?

    // MARK: - Inits

    init(withItem item: Item, delegate: StoryDetailNodeDelegate? = nil) {
        super.init()

        self.delegate = delegate

        // Poster button
        self.posterNode = ASButtonNode()
        if !item.by.isEmpty && item.time > 0 {
            self.posterNode.setAttributedTitle(
                NSAttributedString(
                    string: "\(item.by) • \(NSDate.init(timeIntervalSince1970: item.time).timeAgo() ?? "")",
                    attributes: Styles.story.poster),
                for: .normal
            )
        }
        self.posterNode.isUserInteractionEnabled = true
        self.posterNode.addTarget(self, action: #selector(self.onPosterButtonPressed(_:)), forControlEvents: .touchUpInside)
        self.addSubnode(self.posterNode)

        // Site button
        self.siteNode = ASButtonNode()
        if !item.url.isEmpty {
            self.siteNode.setAttributedTitle(
                NSAttributedString(
                    string: " • \(item.url.domainName())",
                    attributes: Styles.story.website),
                for: .normal
            )
        }
        self.siteNode.isUserInteractionEnabled = true
        self.siteNode.addTarget(self, action: #selector(self.onSiteButtonPressed(_:)), forControlEvents: .touchUpInside)
        self.addSubnode(self.siteNode)

        // Title text
        self.titleNode = ASTextNode()
        self.titleNode.attributedText = NSAttributedString(
            string: item.title,
            attributes: Styles.storyDetails.title)
        self.titleNode.isUserInteractionEnabled = true
        self.titleNode.addTarget(self, action: #selector(self.onTitlePressed(_:)), forControlEvents: .touchUpInside)
        self.addSubnode(self.titleNode)

        // Text
        if !item.text.isEmpty {
            self.textNode = ASTextNode()
            self.textNode.attributedText = NSMutableAttributedString(
                string: item.text,
                attributes: Styles.storyDetails.text).detectLinks()
            self.textNode.isUserInteractionEnabled = true
            self.textNode.linkAttributeNames = [Constants.kTextLinkAttributeName]
            self.textNode.passthroughNonlinkTouches = true
            self.textNode.delegate = self
            self.addSubnode(self.textNode)
        }

        // Divider
        self.dividerNode = ASDisplayNode()
        self.addSubnode(self.dividerNode)

        self.setupTheme()
    }

    // MARK: - Layout

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        // poster + site
        let headerStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 0,
            justifyContent: .start,
            alignItems: .center,
            children: [self.posterNode, self.siteNode])

        var contentChildren: [ASLayoutElement] = [headerStack, self.titleNode]
        if self.textNode != nil {
            contentChildren.append(self.textNode)
        }

        // header stack + title + text
        let contentStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: HNDimensions.padding,
            justifyContent: .center,
            alignItems: .start,
            children: contentChildren)

        let insetContentStack = ASInsetLayoutSpec(
            insets: UIEdgeInsetsMake(HNDimensions.padding / 2, HNDimensions.padding,
                                     0, HNDimensions.padding),
            child: contentStack)

        return insetContentStack
    }

    override func layout() {
        super.layout()

        // arrange the divider
        let distanceBetweenPosterAndTitle = self.titleNode.frame.minY - self.posterNode.frame.maxY
        self.dividerNode.frame = CGRect(
            x: HNDimensions.padding,
            y: self.posterNode.frame.maxY + distanceBetweenPosterAndTitle / 2,
            width: self.calculatedSize.width - 2 * HNDimensions.padding,
            height: 1)
    }

    // MARK: - IBActions

    func onSiteButtonPressed(_ sender: ASDisplayNode) {
        self.delegate?.storyDetail?(self, didPressSiteButtonWithSender: sender)
    }

    func onPosterButtonPressed(_ sender: ASDisplayNode) {
        self.delegate?.storyDetail?(self, didPressPosterButtonWithSender: sender)
    }

    func onTitlePressed(_ sender: ASDisplayNode) {
        self.delegate?.storyDetail?(self, didPressTitleWithSender: sender)
    }

}

// MARK: - ASTextNodeDelegate

extension StoryDetailNode: ASTextNodeDelegate {

    func textNode(_ textNode: ASTextNode, shouldHighlightLinkAttribute attribute: String, value: Any, at point: CGPoint) -> Bool {
        return true
    }

    func textNode(_ textNode: ASTextNode, tappedLinkAttribute attribute: String, value: Any, at point: CGPoint, textRange: NSRange) {
        if let value = value as? URL {
            self.delegate?.storyDetail?(self, didPressLink: value.absoluteString, withSender: textNode)
        }
    }

}
