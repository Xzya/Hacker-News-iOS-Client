//
//  AuthButton.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/12/16.
//  Copyright © 2016 Null. All rights reserved.
//

import AsyncDisplayKit

class FullButtonNode: ASButtonNode {

    // MARK: - Inits

    override init() {
        super.init()

        self.setupTheme()
    }

    // MARK: - Helpers

    func set(title: String) {
        self.setAttributedTitle(
            NSAttributedString.init(
                string: title,
                attributes: Styles.others.fullButton),
            for: .normal
        )
    }

}
