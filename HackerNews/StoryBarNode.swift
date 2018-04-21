//
//  ItemNode.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/22/16.
//  Copyright © 2016 Null. All rights reserved.
//

import AsyncDisplayKit

class StoryBarNode: ASDisplayNode {

    // MARK: - Properties

    var shareIconNode = ASTextNode()
    var shareTextNode = ASTextNode()
    var commentsIconNode = ASTextNode()
    var commentsTextNode = ASTextNode()
    var votesIconNode = ASTextNode()
    var votesTextNode = ASTextNode()
    var leftDividerNode = ASDisplayNode()
    var rightDividerNode = ASDisplayNode()

    weak var delegate: StoryBarDelegate?

    var itemId: Int = -1

    // MARK: - Inits

    init(withItem item: Item) {
        super.init()

        self.itemId = item.id

        self.automaticallyManagesSubnodes = true

        // share icon
        self.shareIconNode.attributedText = NSAttributedString(
            string: IonIconType.ion_ios_upload.rawValue,
            attributes: Styles.storyBar.icon
        )

        // share text
        self.shareTextNode.attributedText = NSAttributedString(
            string: "Share",
            attributes: Styles.storyBar.button
        )

        // comments icon
        self.commentsIconNode.attributedText = NSAttributedString(
            string: IonIconType.ion_chatbox.rawValue,
            attributes: Styles.storyBar.icon
        )

        // comments text
        self.commentsTextNode.attributedText = NSAttributedString(
            string: "\(item.descendants)",
            attributes: Styles.storyBar.button
        )

        // votes icon
        self.votesIconNode.attributedText = NSAttributedString(
            string: IonIconType.ion_arrow_up_a.rawValue,
            attributes: ItemProvider.didVote(item: item) ? Styles.storyBar.highlightedIcon : Styles.storyBar.icon
        )

        // votes text
        self.votesTextNode.attributedText = NSAttributedString(
            string: "\(item.score)",
            attributes: Styles.storyBar.button
        )

        // left divider
        self.leftDividerNode = ASDisplayNode()
        self.addSubnode(self.leftDividerNode)

        // right divider
        self.rightDividerNode = ASDisplayNode()
        self.addSubnode(self.rightDividerNode)

        // setup the theme
        self.setupTheme()
    }

    // MARK: - Helpers

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self.view) {
            if location.x < self.frame.width / 3 {
                self.onShareButtonPressed(self.shareTextNode)
            } else if location.x < self.frame.width - self.frame.width / 3 {
                self.onCommentsButtonPressed(self.commentsTextNode)
            } else {
                self.onVoteButtonPressed(self.votesTextNode)
            }
        }
    }

    func set(upvoted: Bool) {
        self.votesIconNode.attributedText = NSAttributedString(
            string: IonIconType.ion_arrow_up_a.rawValue,
            attributes: upvoted ? Styles.storyBar.highlightedIcon : Styles.storyBar.icon
        )
    }

    // MARK: - Layout

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        self.style.width = .init(unit: .fraction, value: 1)
        self.style.height = .init(unit: .points, value: HNDimensions.itemBar.height)

        let shareStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: HNDimensions.padding / 2,
            justifyContent: .center,
            alignItems: .center,
            children: [self.shareIconNode, self.shareTextNode])
        shareStack.style.width = .init(unit: .fraction, value: 1/3)

        let commentStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: HNDimensions.padding / 2,
            justifyContent: .center,
            alignItems: .center,
            children: [self.commentsIconNode, self.commentsTextNode])
        commentStack.style.width = .init(unit: .fraction, value: 1/3)

        let voteStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: HNDimensions.padding / 2,
            justifyContent: .center,
            alignItems: .center,
            children: [self.votesIconNode, self.votesTextNode])
        voteStack.style.width = .init(unit: .fraction, value: 1/3)

        let mainStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 0,
            justifyContent: .spaceAround,
            alignItems: .center,
            children: [shareStack, commentStack, voteStack])

        return mainStack
    }

    override func layout() {
        super.layout()

        let width = self.calculatedSize.width
        let height = self.calculatedSize.height

        // arrange the dividers
        self.leftDividerNode.frame = CGRect(x: width / 3, y: height / 2 - HNDimensions.itemBar.dividerHeight / 2, width: 1, height: HNDimensions.itemBar.dividerHeight)
        self.rightDividerNode.frame = CGRect(x: 2 * width / 3, y: height / 2 - HNDimensions.itemBar.dividerHeight / 2, width: 1, height: HNDimensions.itemBar.dividerHeight)
    }

    // MARK: - IBActions

    func onShareButtonPressed(_ sender: ASDisplayNode) {
        self.delegate?.storyBar?(self, didPressShareButtonWithSender: sender)
    }

    func onCommentsButtonPressed(_ sender: ASDisplayNode) {
        self.delegate?.storyBar?(self, didPressCommentsButtonWithSender: sender)
    }

    func onVoteButtonPressed(_ sender: ASDisplayNode) {
        self.delegate?.storyBar?(self, didPressVoteButtonWithSender: sender)
    }

}
