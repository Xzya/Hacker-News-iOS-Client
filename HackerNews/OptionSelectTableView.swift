//
//  OptionSelectTableView.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/23/16.
//  Copyright © 2016 Null. All rights reserved.
//

import AsyncDisplayKit

class OptionSelectTableView: ASTableNode {

    // MARK: - Lifecycle

    init() {
        super.init(style: .plain)

        self.setup()
    }

    // MARK: - Setup Helpers

    func setup() {
        self.setupTableView()
        self.setupTheme()
    }

    func setupTableView() {
        self.view.separatorStyle = .singleLine
        self.view.separatorInset = UIEdgeInsets.zero
        self.view.tableFooterView = UIView()
        self.view.layoutMargins = UIEdgeInsets.zero
        self.view.bounces = false
    }

    // MARK: - Layout

    override func layout() {
        super.layout()

        if let superview = self.view.superview {
            let height = min(superview.frame.height - 32, self.view.contentSize.height)
            self.frame = CGRect(
                x: HNDimensions.padding / 2,
                y: superview.frame.height - height - HNDimensions.padding / 2,
                width: superview.frame.width - HNDimensions.padding,
                height: height)
        }
    }

}
