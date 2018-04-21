//
//  CommentOptionsNode.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/23/16.
//  Copyright © 2016 Null. All rights reserved.
//

import AsyncDisplayKit

class CommentOptionsNode: ASCellNode {

    // MARK: - Properties

    var moreNode = ASTextNode()
    var replyIconNode = ASTextNode()
    var replyTextNode = ASTextNode()
    var voteNode = ASTextNode()
    var topDividerNode = ASDisplayNode()
    var bottomDividerNode = ASDisplayNode()

    var item = Item()

    weak var delegate: CommentOptionsNodeDelegate?

    // MARK: - Inits

    init(withItem item: Item, commentOptionsDelegate: CommentOptionsNodeDelegate? = nil) {
        super.init()

        self.item = item
        self.delegate = commentOptionsDelegate

        self.automaticallyManagesSubnodes = true

        // more icon
        self.moreNode.attributedText = NSAttributedString(
            string: IonIconType.ion_more.rawValue,
            attributes: Styles.commentOptions.icon
        )

        // reply icon
        self.replyIconNode.attributedText = NSAttributedString(
            string: IonIconType.ion_reply.rawValue,
            attributes: Styles.commentOptions.icon
        )

        // reply text
        self.replyTextNode.attributedText = NSAttributedString(
            string: "Reply",
            attributes: Styles.commentOptions.text
        )

        // vote icon
        self.voteNode.attributedText = NSAttributedString(
            string: IonIconType.ion_arrow_up_a.rawValue,
            attributes: ItemProvider.didVote(item: item) ? Styles.commentOptions.highlightedIcon : Styles.commentOptions.icon
        )

        // top divider
        self.addSubnode(self.topDividerNode)

        // bottom divider
        self.addSubnode(self.bottomDividerNode)

        self.setupTheme()
    }

    // MARK: - Helpers

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self.view) {
            if location.x < self.frame.width / 3 {
                self.onMoreButtonPressed(self.moreNode)
            } else if location.x < self.frame.width - self.frame.width / 3 {
                self.onReplyButtonPressed(self.replyTextNode)
            } else {
                self.onVoteButtonPressed(self.voteNode)
            }
        }
    }

    func set(upvoted: Bool) {
        self.voteNode.attributedText = NSAttributedString(
            string: IonIconType.ion_arrow_up_a.rawValue,
            attributes: upvoted ? Styles.commentOptions.highlightedIcon : Styles.commentOptions.icon
        )
    }

    // MARK: - Layout

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        // more stack
        let moreStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: HNDimensions.padding / 2,
            justifyContent: .center,
            alignItems: .center,
            children: [self.moreNode])
        moreStack.style.width = .init(unit: .fraction, value: 1/2)

        // TODO: - uncomment when replying to post is supported, also change 2 to 3 above
        // reply stack
//        let replyStack = ASStackLayoutSpec(
//            direction: .horizontal,
//            spacing: HNDimensions.padding / 2,
//            justifyContent: .center,
//            alignItems: .center,
//            children: [self.replyIconNode, self.replyTextNode])
//        replyStack.style.width = .init(unit: .fraction, value: 1/3)

        // vote stack
        let voteStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: HNDimensions.padding / 2,
            justifyContent: .center,
            alignItems: .center,
            children: [self.voteNode])
        voteStack.style.width = .init(unit: .fraction, value: 1/2)

        // main stack
        let mainStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 0,
            justifyContent: .spaceAround,
            alignItems: .center,
            children: [moreStack /*, replyStack */, voteStack])

        // top/bottom insets
        let insetStack = ASInsetLayoutSpec(
            insets: UIEdgeInsetsMake(
                HNDimensions.padding, 0,
                HNDimensions.padding, 0),
            child: mainStack)

        return insetStack
    }

    override func layout() {
        super.layout()

        let width = self.calculatedSize.width
        let dividerWidth = width - HNDimensions.padding

        // arrange the dividers
        self.topDividerNode.frame = CGRect(
            x: HNDimensions.padding / 2,
            y: 0,
            width: dividerWidth,
            height: 1)
        self.bottomDividerNode.frame = CGRect(
            x: HNDimensions.padding / 2,
            y: self.frame.maxY - 1,
            width: dividerWidth,
            height: 1)
    }

    // MARK: - IBActions

    func onMoreButtonPressed(_ sender: ASDisplayNode) {
        self.delegate?.commentOptions?(self, didPressMoreButtonWithSender: sender)
    }

    func onReplyButtonPressed(_ sender: ASDisplayNode) {
        self.delegate?.commentOptions?(self, didPressReplyButtonWithSender: sender)
    }

    func onVoteButtonPressed(_ sender: ASDisplayNode) {
        self.delegate?.commentOptions?(self, didPressVoteButtonWithSender: sender)
    }

}
