//
//  StoryNode.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/22/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Foundation
import AsyncDisplayKit

/**
 * Story cell.
 */
class StoryNode: ASCellNode {

    // MARK: - Properties

    /**
     * The poster of the story.
     */
    var posterNode = ASButtonNode()

    /**
     * The website of the story.
     */
    var siteNode = ASTextNode()

    /**
     * The title of the story.
     */
    var titleNode = ASTextNode()

    /**
     * The story bar node. Contains the story controls like share, comments, upvotes.
     */
    var storyBarNode: StoryBarNode!

    /**
     * Story node delegate.
     */
    weak var delegate: StoryNodeDelegate?

    // MARK: - Inits

    init(withItem item: Item, storyNodeDelegate delegate: StoryNodeDelegate? = nil, storyBarDelegate: StoryBarDelegate? = nil) {
        super.init()

        // save properties
        self.delegate = delegate

        self.selectionStyle = .none

        self.automaticallyManagesSubnodes = true

        // Poster button
        self.posterNode.setAttributedTitle(
            NSAttributedString(
                string: "\(item.by) • \(NSDate.init(timeIntervalSince1970: item.time).timeAgo() ?? "")",
                attributes: Styles.story.poster),
            for: UIControlState.normal
        )
        self.posterNode.isUserInteractionEnabled = true
        self.posterNode.addTarget(self, action: #selector(self.onPosterButtonPressed(_:)), forControlEvents: .touchUpInside)

        // Site button
        if !item.url.isEmpty {
            self.siteNode.attributedText = NSAttributedString(
                string: " • \(item.url.domainName())",
                attributes: Styles.story.website)
            self.siteNode.truncationMode = .byTruncatingTail
            self.siteNode.maximumNumberOfLines = 1
            self.siteNode.style.flexShrink = 1
        }

        // Title text
        self.titleNode.attributedText = NSAttributedString(
            string: item.title,
            attributes: ItemProvider.didRead(itemWithId: item.id) ? Styles.story.seenTitle : Styles.story.title)

        // Story Bar
        self.storyBarNode = StoryBarNode(withItem: item)
        self.storyBarNode.delegate = storyBarDelegate

        // setup the theme
        self.setupTheme()
    }

    // MARK: - Layout

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        // story bar
        self.storyBarNode.style.width = .init(unit: .fraction, value: 1)
        self.storyBarNode.style.height = .init(unit: .points, value: HNDimensions.itemBar.height)

        // poster + site
        let headerStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 0,
            justifyContent: .start,
            alignItems: .center,
            children: [self.posterNode, self.siteNode])

        // header stack + title
        let contentStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: HNDimensions.padding / 4,
            justifyContent: .center,
            alignItems: .start,
            children: [headerStack, self.titleNode])

        let insetContentStack = ASInsetLayoutSpec(
            insets: UIEdgeInsetsMake(HNDimensions.padding / 2,
                                     HNDimensions.padding,
                                     0,
                                     HNDimensions.padding
            ),
            child: contentStack)

        let mainStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 0,
            justifyContent: .center,
            alignItems: .start,
            children: [insetContentStack, self.storyBarNode])

        return mainStack
    }

    // MARK: - IBActions

    func onPosterButtonPressed(_ sender: ASDisplayNode) {
        self.delegate?.storyNode?(self, didPressOnPosterButton: sender)
    }

}
