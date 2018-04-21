//
//  WebViewNode.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/23/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class WebViewNode: ASDisplayNode {

    // MARK: - Properties

    var webView = UIWebView()
    var webViewNode = ASDisplayNode()
    var storyBarNode: StoryBarNode!

    var delegate: UIWebViewDelegate? {
        set {
            self.webView.delegate = newValue
        }
        get {
            return self.webView.delegate
        }
    }

    var storyBarDelegate: StoryBarDelegate? {
        set {
            self.storyBarNode?.delegate = newValue
        }
        get {
            return self.storyBarNode?.delegate
        }
    }

    // MARK: - Inits

    init(withItem item: Item) {
        super.init()

        self.commonInit()

        // story bar node
        self.storyBarNode = StoryBarNode(withItem: item)
    }

    override init() {
        super.init()

        self.commonInit()
    }

    func commonInit() {
        self.automaticallyManagesSubnodes = true
        self.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]

        // web view
        self.webViewNode = ASDisplayNode { () -> UIView in
            self.webView.scalesPageToFit = true
            self.webView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
            return self.webView
        }

        self.setupTheme()
    }

    // MARK: - Helpers

    func setupTheme() {
        self.backgroundColor = UIColor.clear
    }

    // MARK: - Layout

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        // story bar
        self.storyBarNode?.style.height = .init(unit: .points, value: HNDimensions.itemBar.height)

        // web view
        if self.storyBarNode != nil {
            self.webViewNode.style.maxSize = CGSize(width: constrainedSize.max.width, height: constrainedSize.max.height - HNDimensions.itemBar.height)
        } else {
            self.webViewNode.style.maxSize = CGSize(width: constrainedSize.max.width, height: constrainedSize.max.height)
        }

        let mainStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 0,
            justifyContent: .spaceAround,
            alignItems: .stretch,
            children: [self.webViewNode])
        mainStack.style.width = .init(unit: .fraction, value: 1)
        mainStack.style.height = .init(unit: .fraction, value: 1)

        if self.storyBarNode != nil {
            mainStack.children?.append(self.storyBarNode)
        }

        let insetStack = ASInsetLayoutSpec(
            insets: UIEdgeInsetsMake(0, 0, 0, 0),
            child: mainStack)

        return insetStack
    }

}
