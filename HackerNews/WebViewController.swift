//
//  WebViewController.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/9/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class WebViewController: BaseViewController {

    // MARK: - IBOutlets

    var webViewNode: WebViewNode!

    var webBackButton: UIBarButtonItem!
    var webForwardButton: UIBarButtonItem!
    var webTitleLabel: UILabel!

    // MARK: - Properties

    var type: WebViewControllerType!

    // MARK: - Lifecycle

    init(item: Item) {
        self.webViewNode = WebViewNode(withItem: item)

        self.type = .item(item)

        super.init(node: self.webViewNode)

        self.hidesBottomBarWhenPushed = true
    }

    init(link: String) {
        self.webViewNode = WebViewNode()

        self.type = .link(link)

        super.init(node: self.webViewNode)

        self.hidesBottomBarWhenPushed = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
    }

    override var previewActionItems: [UIPreviewActionItem] {
        let shareAction = UIPreviewAction(title: "Share page", style: .default) { (action, viewController) in
            switch self.type! {
            case .item(let item):
                ShareHelper.share(items: item.shareContent(), fromViewController: AppDelegate.tabBarController, sourceView: nil)
            case .link(let link):
                ShareHelper.share(items: [link], fromViewController: AppDelegate.tabBarController, sourceView: nil)
            }

        }
        return [shareAction]
    }

    // MARK: - Setup Helpers

    func setup() {
        self.setupTheme()
        self.setupWebViewNode()
        self.setupNavigationItem()
        self.setupWebNavigationItems()
        self.toggleWebNavigationButtons()
        self.setupNavigationTitle()
        self.toggleWebNavigationButtons()

        self.loadPage()
    }

    func setupWebViewNode() {
        self.webViewNode.delegate = self
        self.webViewNode.storyBarDelegate = self
    }

    func setupNavigationItem() {
        self.navigationItem.set(rightButtonIcon: .ion_more, target: self, action: #selector(self.onRightNavigationItemPressed))
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    func setupWebNavigationItems() {
        self.webBackButton = UIBarButtonItem(
            title: IonIconType.ion_chevron_left.rawValue,
            style: .plain,
            target: self,
            action: #selector(self.onWebBackButtonPressed))
        self.webForwardButton = UIBarButtonItem(
            title: IonIconType.ion_chevron_right.rawValue,
            style: .plain,
            target: self,
            action: #selector(self.onWebForwardButtonPressed))

        self.webBackButton.setTitleTextAttributes(Styles.navigation.icon, for: .normal)
        self.webForwardButton.setTitleTextAttributes(Styles.navigation.icon, for: .normal)

        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItem = self.webBackButton
        self.navigationItem.rightBarButtonItems?.append(self.webForwardButton)
    }

    func setupNavigationTitle() {
        self.webTitleLabel = UILabel()
        self.webTitleLabel.attributedText = NSAttributedString(
            string: self.currentURL().domainName(),
            attributes: Styles.navigation.website
        )
        self.webTitleLabel.sizeToFit()
        self.webTitleLabel.textAlignment = .center
        self.navigationItem.titleView = self.webTitleLabel
    }

    // MARK: - Helpers

    func loadPage() {
        var urlString = ""

        switch self.type! {
        case .item(let item):
            urlString = item.url
        case .link(let link):
            urlString = link
        }

        if let url = URL.init(string: urlString) {
            self.webViewNode.webView.loadRequest(URLRequest(url: url))
        }
    }

    func currentURL() -> String {
        if let url = self.webViewNode.webView.request?.url?.absoluteString {
            return url
        }

        switch self.type! {
        case .item(let item):
            return item.url
        case .link(let link):
            return link
        }
    }

    func toggleWebNavigationButtons() {
        self.webBackButton.isEnabled = self.webViewNode.webView.canGoBack
        self.webForwardButton.isEnabled = self.webViewNode.webView.canGoForward

        // if the left button is enabled but not added, add it
        if self.webBackButton.isEnabled, self.navigationItem.leftBarButtonItem == nil {
            self.navigationItem.leftBarButtonItem = self.webBackButton
        }
            // else if the button is not enabled but it's added, remove it
        else if !self.webBackButton.isEnabled, self.navigationItem.leftBarButtonItem != nil {
            self.navigationItem.leftBarButtonItem = nil
        }

        // if the right button is enabled
        if self.webForwardButton.isEnabled, let rightItems = self.navigationItem.rightBarButtonItems {
            // if it's not added, add it
            if rightItems.count < 2 {
                self.navigationItem.rightBarButtonItems?.append(self.webForwardButton)
            }
        }
            // if the right button is not enabled
        else if !self.webForwardButton.isEnabled, let rightItems = self.navigationItem.rightBarButtonItems {
            // if we have more than 1 item, remove the last one
            if rightItems.count > 1 {
                self.navigationItem.rightBarButtonItems?.removeLast()
            }
        }
    }

    func updateTitleLabel() {
        self.webTitleLabel.attributedText = NSAttributedString(
            string: self.currentURL().domainName(),
            attributes: Styles.navigation.website
        )
        self.webTitleLabel.sizeToFit()
    }

    // MARK: - IBActions

    func onWebBackButtonPressed() {
        self.webViewNode.webView.goBack()
    }

    func onWebForwardButtonPressed() {
        self.webViewNode.webView.goForward()
    }

    func onRightNavigationItemPressed() {
        AppDelegate.tabBarController.present(OptionsViewController(delegate: self), animated: true, completion: nil)
    }

}

// MARK: - UIWebViewDelegate

extension WebViewController: UIWebViewDelegate {


    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.updateTitleLabel()
        self.toggleWebNavigationButtons()
    }

}

// MARK: - StoryBarDelegate

extension WebViewController: StoryBarDelegate {

    func storyBar(_ storyBar: StoryBarNode, didPressShareButtonWithSender sender: ASDisplayNode) {
        switch self.type! {
        case .item(let item):
            ShareHelper.share(items: item.shareContent(), fromViewController: self, sourceView: sender.view)
        default: break
        }
    }

    func storyBar(_ storyBar: StoryBarNode, didPressCommentsButtonWithSender sender: ASDisplayNode) {
        if !self.navController.pop(toViewControllerOfType: CommentsViewController.classForCoder()) {
            switch self.type! {
            case .item(let item):
                self.navController.push(viewController: CommentsViewController(item: item))
            default: break
            }
        }
    }

    func storyBar(_ storyBar: StoryBarNode, didPressVoteButtonWithSender sender: ASDisplayNode) {
        if self.authenticated() {
            if let item = ItemProvider.item(withId: storyBar.itemId) {
                let up = !ItemProvider.didVote(item: item)
                up ? ItemProvider.vote(item: item) : ItemProvider.removeVote(item: item)

                storyBar.set(upvoted: up)

                HNAPI.vote(item: item, up: up)
                    .then { Void -> Void in
                        print("Voted \(item.id)")
                    }.catch { error in
                        up ? ItemProvider.removeVote(item: item) : ItemProvider.vote(item: item)
                        print(error) // TODO: - Handle this
                }
            }
        }
    }

}

// MARK: - OptionSelectViewDelegate

/**
 * There are 2 sections.
 * Cancel
 * Options
 */
enum WebSectionType: Int {
    case options = 0
    case cancel = 1

    static var count: Int {
        return 2
    }
}

extension WebViewController: OptionSelectViewDelegate {

    func numberOfSections(in optionSelectView: OptionsViewController) -> Int {
        return WebSectionType.count
    }

    func optionSelectView(optionSelectView: OptionsViewController, numberOfItemsInSection section: Int) -> Int {

        guard let sectionType = WebSectionType(rawValue: section) else {
            assertionFailure("Web section \(section) not found.")
            return -1
        }

        // check section
        switch sectionType {

        // close
        case .cancel:
            return 1

        // options
        case .options:
            return WebOptionType.values.count
        }

    }

    func optionSelectView(optionSelectView: OptionsViewController, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {

            guard let sectionType = WebSectionType(rawValue: indexPath.section) else {
                assertionFailure("Web section \(indexPath.section) not found.")
                return ASCellNode()
            }

            // check section
            switch sectionType {

            // cancel
            case .cancel:
                return HNOptionActionNode(optionType: GeneralType.cancel)

            // options
            case .options:
                return OptionSelectNode(
                    optionType: WebOptionType.values[indexPath.row],
                    selected: false
                )

            }
        }
    }

    func optionSelectView(optionSelectView: OptionsViewController, didSelectItemAtIndexPath indexPath: IndexPath) {

        guard let sectionType = WebSectionType(rawValue: indexPath.section) else {
            assertionFailure("Web section \(indexPath.section) not found.")
            return;
        }

        // check section
        switch sectionType {

        // cancel
        case .cancel:
            return;

        // options
        case .options:

            let option = WebOptionType.values[indexPath.row]

            switch option {
            case .refresh:
                self.webViewNode.webView.reload()

            case .share:
                ShareHelper.share(items: [self.currentURL()], fromViewController: self, sourceView: self.view)

            case .openInBrowser:
                Utils.openURL(urlString: self.currentURL())
            }
        }
    }

}
