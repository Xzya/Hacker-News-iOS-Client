//
//  TextFieldNode.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/12/16.
//  Copyright © 2016 Null. All rights reserved.
//

import AsyncDisplayKit

class TextFieldNode: ASEditableTextNode {

    // MARK: - Inits

    override init() {
        super.init()

        self.setupTheme()
    }

    override init(textKitComponents: ASTextKitComponents, placeholderTextKitComponents: ASTextKitComponents) {
        super.init(textKitComponents: textKitComponents, placeholderTextKitComponents: placeholderTextKitComponents)
    }

    // MARK: - Helpers

    func set(placeholderText: String) {
        self.attributedPlaceholderText = NSAttributedString(
            string: placeholderText,
            attributes: Styles.textField.placeholder
        )
    }

}
