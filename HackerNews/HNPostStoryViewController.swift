//
//  HNPostStoryViewController.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 6/5/17.
//  Copyright © 2017 Null. All rights reserved.
//

import AsyncDisplayKit

class HNPostStoryViewController: BaseViewController {

    // MARK: - IBOutlets

    var postStoryNode: HNPostStoryNode!

    // MARK: - Lifecycle

    init() {
        self.postStoryNode = HNPostStoryNode()
        super.init(node: self.postStoryNode)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
    }

    // MARK: - Setup Helpers

    func setup() {
        self.setupTheme()
        self.setupNode()
        self.setupNavigationItem()
    }

    func setupNode() {
        self.postStoryNode.delegate = self
        self.postStoryNode.frame = self.view.bounds
        self.postStoryNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    func setupNavigationItem() {
        self.navigationItem.set(leftButtonIcon: .ion_close, target: self, action: #selector(self.close))
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

    func close() {
        self.dismiss(animated: true, completion: nil)
    }

}

// MARK: - HNPostStoryDelegate

extension HNPostStoryViewController: HNPostStoryDelegate {

    func postStory(didPressSubmitButton button: ASDisplayNode, title: String, url: String, text: String) {

        // make sure the data is valid
        if self.validateData(title: title, url: url, text: text) {

            // show the loader
            self.showLoader()

            // post the story
            HNAPI.postStory(title: title, url: url, text: text)
                .then { Void -> Void in

                    // TODO: - Redirect to story? Do we get this in the response or headers?
                    self.close()

                }.always {
                    self.hideLoader()
                }.catch { error in
                    AlertBuilder().set(title: "Error")
                        .set(message: error.localizedDescription)
                        .add(actionWithTitle: "OK")
                        .present(sender: self)
            }

        }
    }

    func postStory(didPressCloseButton button: ASDisplayNode) {
        self.close()
    }

}
