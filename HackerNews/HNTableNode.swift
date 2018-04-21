//
//  HNTableView.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/12/16.
//  Copyright © 2016 Null. All rights reserved.
//

import AsyncDisplayKit

class HNTableNode: ASTableNode {

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
        self.view.alwaysBounceVertical = true
        self.view.layoutMargins = UIEdgeInsets.zero
        self.clipsToBounds = true
    }

}
